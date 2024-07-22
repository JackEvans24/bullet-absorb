class_name Reticule
extends Node3D

@export var min_reticule_distance := 1.0
@export var max_reticule_distance := 6.0
@export var line_offset := Vector3(0, 0, 0.5)
@export_range(0.01, 1.0) var line_length_multiplier := 0.5

@onready var reticule_mesh: MeshInstance3D = $Mesh
@onready var distance_check: RayCast3D = $DistanceCheck

func _ready():
    distance_check.target_position = Vector3.FORWARD * max_reticule_distance

func _physics_process(_delta):
    if not distance_check.is_colliding():
        set_mesh_positions(Vector3.FORWARD * max_reticule_distance)
        return

    var collision_point = to_local(distance_check.get_collision_point())
    if collision_point.length() < min_reticule_distance:
        collision_point = collision_point.normalized() * min_reticule_distance
    set_mesh_positions(collision_point)

func set_mesh_positions(reticule_position: Vector3):
    reticule_mesh.position = reticule_position