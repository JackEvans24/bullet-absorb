class_name Enemy
extends CharacterBody3D

signal died

@export var hurt_particles_scene: PackedScene
@export var orb_scene: PackedScene
@export var orb_power_count := 3
@export var knockback_material: Material

@onready var health: Health = $Health
@onready var knockback: Knockback = $Knockback
@onready var hit_detection: Area3D = $HitDetection
@onready var pivot: Node3D = $Pivot
@onready var collider: CollisionShape3D = $Collider

var meshes: Array[MeshInstance3D] = []

func _ready():
	get_meshes_recursive(pivot)

func get_meshes_recursive(node: Node):
	for child in node.get_children():
		if child.name == "SpawnTube":
			continue
		if child is MeshInstance3D:
			meshes.push_back(child as MeshInstance3D)
		get_meshes_recursive(child)

func set_hit_detection():
	hit_detection.area_entered.connect(_on_area_entered)
	health.damage_taken.connect(_on_damage_taken)
	knockback.knockback_changed.connect(_on_knockback_changed)

func _physics_process(_delta):
	velocity = knockback.knockback_direction
	move_and_slide()

func _on_area_entered(area: Area3D):
	health.take_damage(1.0, area)

func _on_damage_taken(damage_taken: float, taken_from: Node3D):
	if damage_taken <= 0:
		return

	add_hurt_particles()
	do_knockback(taken_from)

	if health.current_health <= 0:
		call_deferred("die")

func _on_knockback_changed(active: bool):
	for mesh in meshes:
		if not is_instance_valid(mesh):
			continue
		mesh.material_override = knockback_material if active else null

func set_target(_target: Node3D):
	pass

func add_hurt_particles():
	var hurt_particles = hurt_particles_scene.instantiate()
	add_child(hurt_particles)
	hurt_particles.position = pivot.position

func do_knockback(taken_from: Node3D):
	var direction = -taken_from.basis.z
	knockback.set_knockback_direction(direction)

func die():
	pivot.visible = false
	collider.call_deferred("queue_free")
	drop_orb()
	died.emit()

func drop_orb():
	var orb = orb_scene.instantiate()
	orb.power_count = orb_power_count
	get_tree().root.add_child(orb)
	orb.global_position = global_position
