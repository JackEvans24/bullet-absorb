class_name PlayerBody
extends Node3D

@export_group("Materials")
@export var default_material: Material
@export var recovery_material: Material

@export_group("Body Movement")
@export var body_ref: NodePath
@export var body_move_amount := 0.5
@export var body_angle_deg := 15.0
@export_range(0.0, 1.0) var body_smoothing := 0.9

@onready var hurt_particles: GPUParticles3D = $HurtParticles
@onready var dash_particles: GPUParticles3D = $DashParticles
@onready var body: Node3D = get_node(body_ref)

var meshes: Array[MeshInstance3D]

var current_move_state: MoveState
var current_movement: Vector3
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
	set_body_angle()
	set_body_materials()

func set_body_angle():
	var move_speed = current_movement.length()
	if move_speed < 0.01:
		body.position = Vector3.ZERO
		body.rotation = Vector3.ZERO
		return

	var local_move = to_local(global_position + current_movement).normalized()
	var target_position = local_move * body_move_amount * move_speed
	body.position = body.position.lerp(target_position, body_smoothing)

	var body_angle = deg_to_rad(body_angle_deg)
	var target_rotation = Vector3(local_move.z, 0.0, -local_move.x) * body_angle * move_speed
	body.rotation = body.rotation.lerp(target_rotation, body_smoothing)

	pass

func set_body_materials():
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
