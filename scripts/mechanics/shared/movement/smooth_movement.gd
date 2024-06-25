class_name SmoothMovement
extends Node3D

@export var max_speed: float = 5.0
@export var min_speed: float = 0.1
@export_range(0.0, 1.0) var dampening: float = 0.1

@onready var actual_dampening = 1 - dampening

var is_target_set := false
var target_position: Vector3
var movement := Vector3.ZERO

func set_target(target: Vector3):
	target_position = target
	is_target_set = true

func clear_target():
	is_target_set = false
	movement = Vector3.ZERO
	target_position = Vector3.ZERO

func _process(delta):
	if not is_target_set or target_position == null:
		return
	update_movement(delta)

func update_movement(delta: float):
	var direction = target_position - global_position

	var offset_magnitude = direction.length() * delta
	if offset_magnitude < min_speed * 0.001:
		return

	var magnitude = get_movement_magnitude(offset_magnitude)
	movement = direction * magnitude

func get_movement_magnitude(offset_magnitude: float) -> float:
	var desired_magnitude = offset_magnitude * actual_dampening
	return minf(desired_magnitude, max_speed * 0.001)