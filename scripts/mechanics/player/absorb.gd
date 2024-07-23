class_name Absorb
extends Node3D

signal bullet_absorbed
signal slowdown_started
signal slowdown_ended
signal absorb_triggered

@export var absorb_windup = 1.0
@export var absorb_cooldown = 0.5
@export var mesh_display_time = 0.2

@onready var destoy_area: Area3D = $DestroyArea
@onready var absorb_area: Area3D = $AbsorbArea
@onready var mesh: MeshInstance3D = $AbsorbMesh
@onready var particles: GPUParticles3D = $AbsorbParticles

var can_absorb = true
var is_absorb_started = false
var is_absorbing = false
var current_windup_time = 0.0
var windup_modifier = 1.0

func _ready():
	absorb_area.area_entered.connect(absorb_power)

func _process(delta):
	if Input.is_action_just_pressed("absorb"):
		process_absorb_start()
	elif is_absorb_started:
		process_absorb_state(delta)

func process_absorb_start():
	if is_absorbing or not can_absorb:
		return

	slowdown_started.emit()
	is_absorb_started = true
	enable_particles(true)

func process_absorb_state(delta):
	if is_absorbing or not can_absorb:
		return

	if not Input.is_action_pressed("absorb"):
		end_absorb()
		return

	current_windup_time += delta
	if not current_windup_time > (absorb_windup / windup_modifier):
		return

	trigger_absorb()
	end_absorb()

func trigger_absorb():
	is_absorbing = true

	absorb_triggered.emit()

	var overlapping_areas: Array[Area3D] = destoy_area.get_overlapping_areas()
	for overlapping_area in overlapping_areas:
		absorb_entity(overlapping_area)

	await display_mesh()
	await handle_cooldown()

	is_absorbing = false

func end_absorb():
	end_windup()
	slowdown_ended.emit()

func end_windup():
	is_absorb_started = false
	current_windup_time = 0.0
	enable_particles(false)

func enable_particles(enabled: bool):
	particles.emitting = enabled
	particles.visible = enabled

func absorb_entity(area: Area3D):
	var absorb_handler = area.find_child("AbsorbHandler")
	if absorb_handler == null:
		printerr("Area has no absorb handler: %s" % area.name)

	absorb_handler.trigger_absorb()

func absorb_power(area: Area3D):
	area.get_parent().call_deferred("queue_free")
	bullet_absorbed.emit()

func handle_cooldown():
	await get_tree().create_timer(absorb_cooldown).timeout

func display_mesh():
	mesh.visible = true
	await get_tree().create_timer(mesh_display_time).timeout
	mesh.visible = false
