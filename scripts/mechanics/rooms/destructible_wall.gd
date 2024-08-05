class_name DestructibleWall
extends Node3D

signal wall_destroyed

@export var bullet_hit_handler_ref: NodePath
@export var meshes_ref: NodePath
@export var collision_shape_ref: NodePath

@onready var bullet_handler: BulletHitHandler = get_node(bullet_hit_handler_ref)
@onready var meshes: DestructibleWallMeshes = get_node(meshes_ref)
@onready var collider: CollisionShape3D = get_node(collision_shape_ref)
@onready var particles: GPUParticles3D = $Pivot/Rubble

func _ready():
	bullet_handler.bullet_connected.connect(_on_bullet_connected)

func mark_ready_to_destroy():
	meshes.can_destroy = true

func _on_bullet_connected(_bullet: Node3D):
	call_deferred("destroy_wall")

func destroy_wall():
	var destruction_state = meshes.try_destroy()
	if destruction_state == DestructibleWallMeshes.DestructionState.Unchanged:
		return

	particles.emitting = true
	if destruction_state == DestructibleWallMeshes.DestructionState.Crumbling:
		return

	collider.queue_free()
	wall_destroyed.emit()
