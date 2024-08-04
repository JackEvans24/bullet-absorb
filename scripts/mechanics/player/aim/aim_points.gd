class_name Reticule
extends Node3D

@export_group("Reticule")
@export var min_reticule_distance := 1.0
@export var max_reticule_distance := 12.0

@export_group("Look At")
@export var min_look_at_distance := 1.0
@export var max_look_at_distance := 6.0

@onready var aim_at_node: Node3D = $AimAt
@onready var camera_follow_node: Node3D = $CameraFollow

var aim_distance := 1.0

func enable_reticule(enable: bool):
    aim_at_node.visible = enable

func _physics_process(_delta):
    var reticule_distance = clampf(aim_distance, min_reticule_distance, max_reticule_distance)
    var look_at_distance = clampf(aim_distance, min_look_at_distance, max_look_at_distance)
    set_mesh_positions(reticule_distance, look_at_distance)

func set_mesh_positions(reticule_distance: float, look_at_distance: float):
    aim_at_node.position.z = -reticule_distance
    camera_follow_node.position.z = -look_at_distance