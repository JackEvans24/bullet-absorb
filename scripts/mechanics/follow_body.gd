class_name FollowBody3D
extends Node3D

@export var max_speed = 5.0
@export var acceleration = 0.1

var target: Node3D = null
var current_speed = 0.0

var movement = Vector3.ZERO

func _physics_process(delta):
	if target == null:
		return

	var offset = target.global_position - global_position

	current_speed = min(current_speed + (acceleration * delta), max_speed)
	current_speed = min(current_speed, offset.length())

	movement = offset.normalized() * current_speed