class_name Absorb
extends Node3D

signal bullet_absorbed
signal slowdown_started
signal slowdown_ended

@export var absorb_windup = 1
@export var absorb_cooldown = 0.5
@export var mesh_display_time = 0.2

@onready var area: Area3D = $AbsorbArea
@onready var mesh: MeshInstance3D = $AbsorbMesh

var is_absorb_started = false
var is_absorbing = false
var current_windup_time = 0.0

func _process(delta):
	if is_absorb_started:
		process_absorb_state(delta)
	elif Input.is_action_just_pressed("absorb"):
		process_absorb_start()

func process_absorb_state(delta):
	if is_absorbing:
		return

	if not Input.is_action_pressed("absorb"):
		end_absorb()
		return

	current_windup_time += delta
	if not current_windup_time > absorb_windup:
		return

	print("ABSORB TRIGGER")

	slowdown_ended.emit()
	await trigger_absorb()

	print("ABSORB END")

func trigger_absorb():
	is_absorbing = true

	var overlapping_areas: Array[Area3D] = area.get_overlapping_areas()
	for overlapping_area in overlapping_areas:
		if overlapping_area.is_in_group('bullet'):
			absorb_bullet(overlapping_area)

	await display_mesh()
	await handle_cooldown()

	end_absorb()

func process_absorb_start():
	print("ABSORB START")
	slowdown_started.emit()
	is_absorb_started = true

func end_absorb():
	is_absorb_started = false
	is_absorbing = false
	current_windup_time = 0.0

func absorb_bullet(bullet_area: Area3D):
	var bullet = type_convert(bullet_area, typeof(Bullet))
	bullet.absorb()

	bullet_absorbed.emit()

func handle_cooldown():
	await get_tree().create_timer(absorb_cooldown).timeout

func display_mesh():
	mesh.visible = true
	await get_tree().create_timer(mesh_display_time).timeout
	mesh.visible = false
