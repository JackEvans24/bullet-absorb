class_name Enemy
extends CharacterBody3D

signal died

@export var hurt_particles_scene: PackedScene
@export var orb_scene: PackedScene
@export var knockback_material: Material

@onready var health: Health = $Health
@onready var knockback: Knockback = $Knockback
@onready var pivot: Node3D = $Pivot
@onready var collider: CollisionShape3D = $Collider
@onready var bullet_handler: BulletHitHandler = $BulletHitHandler

var meshes: Array[MeshInstance3D] = []

var orb_power_count := 3
var starting_health := 3.0

var is_dead := false
var knockback_active := false

func _ready():
	get_meshes_recursive(pivot)
	set_hit_detection()
	health.current_health = starting_health

func get_meshes_recursive(node: Node):
	for child in node.get_children():
		if child.name == "SpawnTube":
			continue
		if child is MeshInstance3D:
			meshes.push_back(child as MeshInstance3D)
		get_meshes_recursive(child)

func set_hit_detection():
	bullet_handler.bullet_connected.connect(_on_bullet_connected)
	health.damage_taken.connect(_on_damage_taken)
	knockback.knockback_changed.connect(_on_knockback_changed)

func activate_knockback():
	knockback_active = true

func initialise(max_health: float, power_count: int):
	orb_power_count = power_count
	starting_health = max_health

func _physics_process(_delta):
	velocity = knockback.knockback_direction
	move_and_slide()

func _on_bullet_connected(bullet: Node3D):
	health.take_damage(1.0, bullet)

func _on_damage_taken(damage_taken: float, taken_from: Node3D):
	if damage_taken <= 0:
		return

	add_hurt_particles()
	do_knockback(taken_from)

	if health.current_health <= 0:
		call_deferred("die")

func add_hurt_particles():
	var hurt_particles = hurt_particles_scene.instantiate()
	get_tree().root.add_child(hurt_particles)
	hurt_particles.global_position = pivot.global_position

func do_knockback(taken_from: Node3D):
	var direction = -taken_from.basis.z if knockback_active else Vector3.ZERO
	knockback.set_knockback_direction(direction)

func _on_knockback_changed(active: bool):
	for mesh in meshes:
		if not is_instance_valid(mesh):
			continue
		mesh.material_override = knockback_material if active else null

func _on_intro_animation_complete():
	if is_dead:
		return
	activate_enemy()

func activate_enemy():
	pass

func set_target(_target: Node3D):
	pass

func die():
	is_dead = true
	pivot.visible = false
	collider.call_deferred("queue_free")
	drop_orb()
	died.emit()

func drop_orb():
	if orb_power_count <= 0:
		return
	var orb = orb_scene.instantiate()
	orb.power_count = orb_power_count
	get_tree().root.add_child(orb)
	orb.global_position = pivot.global_position
