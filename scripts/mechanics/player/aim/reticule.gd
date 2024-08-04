class_name Reticule
extends Node3D

@export_group("Reticule")
@export var min_reticule_distance := 1.0
@export var max_reticule_distance := 12.0

@export_group("Look At")
@export var min_look_at_distance := 1.0
@export var max_look_at_distance := 6.0

@onready var reticule_mesh: MeshInstance3D = $Mesh
@onready var look_at_node: Node3D = $LookAt
@onready var distance_check: RayCast3D = $DistanceCheck

var aim_distance := 1.0

func _ready():
    distance_check.target_position = Vector3.FORWARD * max_reticule_distance

func enable_reticule(enable: bool):
    reticule_mesh.visible = enable

func _physics_process(_delta):
    var target_distance = aim_distance
    if distance_check.is_colliding():
        var collision_distance = to_local(distance_check.get_collision_point()).length()
        target_distance = min(target_distance, collision_distance)

    var reticule_distance = clampf(target_distance, min_reticule_distance, max_reticule_distance)
    var look_at_distance = clampf(target_distance, min_look_at_distance, max_look_at_distance)
    set_mesh_positions(reticule_distance, look_at_distance)

func set_mesh_positions(reticule_distance: float, look_at_distance: float):
    reticule_mesh.position.z = -reticule_distance
    look_at_node.position.z = -look_at_distance