class_name LookAtTarget
extends Node

var target: Node3D
var pivot: Node3D

func _process(_delta):
	if pivot == null or target == null:
		return

	var target_position = target.global_position
	target_position.y = pivot.global_position.y

	pivot.look_at(target_position)