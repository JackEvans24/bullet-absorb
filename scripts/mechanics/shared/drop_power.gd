class_name DropPower
extends Node3D

@export var power_scene: PackedScene
@export_range(0, 20) var power_drop_count := 3
@export var power_drop_offset = 0.5
@export var offset_deviation = 0.05

func drop_all_power():
	if power_scene == null or power_drop_count <= 0:
		return
	for i in range(power_drop_count):
		drop_single_power(float(i) / power_drop_count)

func drop_single_power(offset_angle: float):
	var power = power_scene.instantiate()
	get_tree().root.add_child(power)

	power.global_position = global_position

	print(offset_angle)
	var deviation = randf_range( - offset_deviation, offset_deviation)
	var angle = PI * 2 * (offset_angle + deviation)
	var offset = Vector3.FORWARD.rotated(Vector3.UP, angle) * power_drop_offset
	power.target_position = global_position + offset