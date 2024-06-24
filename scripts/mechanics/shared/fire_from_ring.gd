class_name FireFromRing
extends Node

@export var pivot_ref: NodePath
@export var bullet_scene: PackedScene

@export_range(2, 30) var bullet_count := 8
@export_range(0.0, 5.0) var pivot_offset := 1.0
@export var rotation_interval := 0.1

@onready var pivot: Node3D = get_node(pivot_ref)

var rotation_offset := 0.0

func fire():
	rotation_offset += rotation_interval
	for i in range(bullet_count):
		generate_bullet(i)

func generate_bullet(i: int):
	var bullet = bullet_scene.instantiate()
	add_child(bullet)

	var bullet_rotation = get_rotation(i) + rotation_offset

	var offset = Vector3.FORWARD.rotated(Vector3.UP, bullet_rotation) * pivot_offset
	bullet.global_position = pivot.global_position + offset
	bullet.initialise(pivot.basis)
	bullet.rotate_y(bullet_rotation)

func get_rotation(i: int) -> float:
	return 2.0 * PI * i / bullet_count
