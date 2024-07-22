class_name PlayerBody
extends Node3D

@export var default_material: Material
@export var recovery_material: Material

@onready var hurt_particles: GPUParticles3D = $HurtParticles
@onready var dash_particles: GPUParticles3D = $DashParticles

var meshes: Array[MeshInstance3D]

var current_move_state: MoveState
var is_invincible: bool = false
var current_material: Material

func _ready():
	get_meshes_recursive(self)

func get_meshes_recursive(node: Node):
	for child in node.get_children():
		if child.name == "Reticule":
			continue
		if child is MeshInstance3D:
			meshes.push_back(child as MeshInstance3D)
		get_meshes_recursive(child)

func _on_invincibility_changed(invincible: bool):
	is_invincible = invincible

func _on_move_state_changed(move_state: MoveState):
	current_move_state = move_state

func _process(_delta):
	var new_material = calculate_current_material()
	if current_material == new_material:
		return
	current_material = new_material

	for mesh in meshes:
		mesh.set_surface_override_material(0, current_material)

func calculate_current_material() -> Material:
	if current_move_state != null and current_move_state.body_material != null:
		return current_move_state.body_material
	if is_invincible:
		return recovery_material
	return default_material

func _on_damage_taken(damage_taken: float, _taken_from: Node3D):
	if damage_taken <= 0:
		return
	hurt_particles.restart()

func _on_player_died():
	visible = false

func _on_dash_triggered(_direction: Vector3):
	dash_particles.restart()
