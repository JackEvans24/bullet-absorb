class_name PlayerAim
extends Node3D

var aim_direction: Vector3 = Vector3.FORWARD

func _process(_delta: float):
	var input_dir = Input.get_vector("aim_right", "aim_left", "aim_back", "aim_forward")
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()

	if direction:
		aim_direction = direction