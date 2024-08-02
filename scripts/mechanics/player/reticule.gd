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

func _ready():
    distance_check.target_position = Vector3.FORWARD * max_reticule_distance

func _physics_process(_delta):
    if not distance_check.is_colliding():
        set_mesh_positions(Vector3.FORWARD, max_reticule_distance, max_look_at_distance)
        return

    var collision_point = to_local(distance_check.get_collision_point())
    var collision_distance = collision_point.length()
    var reticule_distance = clampf(collision_distance, min_reticule_distance, max_reticule_distance)
    var look_at_distance = clampf(collision_distance, min_look_at_distance, max_look_at_distance)
    set_mesh_positions(collision_point.normalized(), reticule_distance, look_at_distance)

func set_mesh_positions(direction: Vector3, reticule_distance: float, look_at_distance: float):
    reticule_mesh.position = direction * reticule_distance
    look_at_node.position = direction * look_at_distance