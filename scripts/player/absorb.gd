class_name Absorb
extends Node3D

signal bullet_absorbed

@export var absorb_cooldown = 0.5
@export var mesh_display_time = 0.2

@onready var area: Area3D = $AbsorbArea
@onready var mesh: MeshInstance3D = $AbsorbMesh

var is_absorbing = false

func _process(_delta):
	if is_absorbing:
		return
	if Input.is_action_just_pressed("absorb"):
		handle_absorb()

func handle_absorb():
	is_absorbing = true

	var overlapping_areas: Array[Area3D] = area.get_overlapping_areas()
	for overlapping_area in overlapping_areas:
		if overlapping_area.is_in_group('bullet'):
			absorb_bullet(overlapping_area)

	display_mesh()
	await handle_cooldown()

	is_absorbing = false

func absorb_bullet(bullet_area: Area3D):
	var bullet = type_convert(bullet_area, typeof(Bullet))
	bullet.absorb()

	bullet_absorbed.emit()

func handle_cooldown():
	var cooldown = maxf(absorb_cooldown, mesh_display_time)
	await get_tree().create_timer(cooldown).timeout

func display_mesh():
	mesh.visible = true
	await get_tree().create_timer(mesh_display_time).timeout
	mesh.visible = false
