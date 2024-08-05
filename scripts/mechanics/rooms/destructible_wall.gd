class_name DestructibleWall
extends Node3D

signal wall_destroyed

@export var bullet_hit_handler_ref: NodePath
@export var mesh_container_ref: NodePath
@export var collision_shape_ref: NodePath

@onready var bullet_handler: BulletHitHandler = get_node(bullet_hit_handler_ref)
@onready var mesh_container: Node3D = get_node(mesh_container_ref)
@onready var collider: CollisionShape3D = get_node(collision_shape_ref)

var can_destroy := false
var is_hit := false

func _ready():
	bullet_handler.bullet_connected.connect(_on_bullet_connected)

func mark_ready_to_destroy():
	can_destroy = true
	if is_hit:
		call_deferred("destroy_wall")

func _on_bullet_connected(_bullet: Node3D):
	if not can_destroy:
		is_hit = true
		return
	call_deferred("destroy_wall")

func destroy_wall():
	mesh_container.visible = false
	collider.queue_free()

	wall_destroyed.emit()