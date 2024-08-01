class_name Absorb
extends Node3D

signal slowdown_started
signal slowdown_ended
signal absorb_triggered

@export var absorb_cooldown = 0.5
@export var mesh_display_time = 0.2

@onready var windup: AbsorbWindup = $AbsorbWindup
@onready var destoy_area: Area3D = $DestroyArea
@onready var particles: GPUParticles3D = $AbsorbParticles

var stats: PlayerStats

var can_absorb = true
var is_absorbing = false

func _process(delta):
	if Input.is_action_just_pressed("absorb"):
		process_absorb_start()
	elif windup.is_windup_active:
		process_absorb_state(delta)

func process_absorb_start():
	if is_absorbing or not can_absorb:
		return

	slowdown_started.emit()
	windup.start_windup()
	enable_particles(true)

func process_absorb_state(_delta):
	if is_absorbing or not can_absorb:
		return

	if not Input.is_action_pressed("absorb"):
		trigger_absorb()

func trigger_absorb():
	if not windup.should_absorb:
		end_absorb()
		return

	is_absorbing = true

	destoy_area.scale = Vector3.ONE * windup.absorb_scale

	absorb_triggered.emit()

	var overlapping_areas: Array[Area3D] = destoy_area.get_overlapping_areas()
	for overlapping_area in overlapping_areas:
		absorb_entity(overlapping_area)

	end_absorb()

	await handle_cooldown()

	is_absorbing = false

func end_absorb():
	end_windup()
	slowdown_ended.emit()

func end_windup():
	windup.end_windup()
	enable_particles(false)

func enable_particles(enabled: bool):
	particles.emitting = enabled
	particles.visible = enabled

func absorb_entity(area: Area3D):
	var absorb_handler = area.find_child("AbsorbHandler")
	if absorb_handler == null:
		printerr("Area has no absorb handler: %s" % area.name)

	absorb_handler.trigger_absorb()

func handle_cooldown():
	await get_tree().create_timer(absorb_cooldown).timeout