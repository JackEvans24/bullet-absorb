class_name PowerGenerator
extends Node3D

@export var power_scene: PackedScene

@onready var power_check_area: Area3D = $PowerCheckArea
@onready var spawn_point: Node3D = $SpawnPoint

func _process(delta):
    if power_check_area.has_overlapping_areas():
        return
    spawn_power()

func spawn_power():
    var power = power_scene.instantiate()
    get_tree().root.add_child(power)
    power.global_position = spawn_point.global_position