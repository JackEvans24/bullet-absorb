class_name PlayerAim
extends Node3D

var aim: Vector3 = Vector3.ZERO

func _physics_process(delta):
	var input_dir = Input.get_vector("aim_left", "aim_right", "aim_forward", "aim_back")
	aim = Vector3(input_dir.x, 0, input_dir.y).normalized()
	# print("Aim: %s" % aim)
