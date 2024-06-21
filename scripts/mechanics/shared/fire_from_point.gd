class_name FireFromPoint
extends Node

@export var fire_point_ref: NodePath
@export var bullet_scene: PackedScene

var pivot: Node3D

@onready var fire_point: Node3D = get_node(fire_point_ref)

func fire():
    if pivot == null:
        printerr("PIVOT IS NULL")
        return

    var bullet = bullet_scene.instantiate()

    bullet.global_position = fire_point.global_position
    bullet.initialise(pivot.basis)

    add_child(bullet)
