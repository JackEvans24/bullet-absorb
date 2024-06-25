class_name Reticule
extends Node3D

@export var max_reticule_distance := 6.0

@onready var mesh: MeshInstance3D = $Mesh
@onready var distance_check: RayCast3D = $DistanceCheck

func _ready():
    distance_check.target_position = Vector3.FORWARD * max_reticule_distance

func _physics_process(_delta):
    if not distance_check.is_colliding():
        mesh.position = Vector3.FORWARD * max_reticule_distance
        return

    mesh.position = to_local(distance_check.get_collision_point())