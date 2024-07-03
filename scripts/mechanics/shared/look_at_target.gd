class_name LookAtTarget
extends Node

@export var max_rotation := 360.0

var target: Node3D
var pivot: Node3D

func _process(delta):
	if pivot == null or target == null:
		return

	var target_position = target.global_position
	target_position.y = pivot.global_position.y

	var direction = target_position - pivot.global_position

	var angle = Vector3.FORWARD.signed_angle_to(direction, Vector3.UP)
	var difference = boundarise_angle(angle - pivot.rotation.y)
	var active_max_rotation = max_rotation * delta

	pivot.rotate_y(clampf(difference, -active_max_rotation, active_max_rotation))
	pivot.rotation.y = boundarise_angle(pivot.rotation.y)

func boundarise_angle(angle: float) -> float:
	if angle > PI:
		return angle - (2 * PI)
	elif angle < - PI:
		return angle + (2 * PI)
	return angle
