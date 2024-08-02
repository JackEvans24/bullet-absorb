class_name ControllerAimDirection
extends AimDirection

var max_aim_distance := 1.0

func get_aim_direction() -> Vector3:
	var input_dir = Input.get_vector("aim_left", "aim_right", "aim_forward", "aim_back")
	return Vector3(input_dir.x, 0, input_dir.y).normalized() * max_aim_distance
