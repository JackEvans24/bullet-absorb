class_name DropPower
extends Node3D

@export var power_scene: PackedScene
@export_range(0, 20) var power_drop_count := 3
@export var power_drop_offset = 0.5

func drop_all_power():
	if power_scene == null or power_drop_count <= 0:
		return
	for i in range(power_drop_count):
		drop_single_power()

func drop_single_power():
	var power = power_scene.instantiate()
	get_tree().root.add_child(power)
	var offset = Vector3.FORWARD.rotated(Vector3.UP, randf_range(0, PI)) * power_drop_offset
	power.global_position = global_position + offset