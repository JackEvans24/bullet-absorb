extends Node3D

@export var max_speed: float = 5.0
@export var min_speed: float = 0.1
@export_range(0.0, 1.0) var dampening: float = 0.1

@onready var actual_dampening = 1 - dampening

var target: Node3D

func _process(delta):
	if target == null:
		return
	update_position(delta)

func update_position(delta: float):
	var direction = target.global_position - global_position

	var offset_magnitude = direction.length() * delta
	if offset_magnitude < min_speed * 0.001:
		return

	var magnitude = get_movement_magnitude(offset_magnitude)
	translate(direction * magnitude)

func get_movement_magnitude(offset_magnitude: float) -> float:
	var desired_magnitude = offset_magnitude * actual_dampening
	return minf(desired_magnitude, max_speed * 0.001)