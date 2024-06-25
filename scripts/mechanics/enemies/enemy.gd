class_name Enemy
extends CharacterBody3D

@export var hurt_particles_scene: PackedScene
@export var power_scene: PackedScene
@export_range(0, 20) var power_drop_count := 3
@export var power_drop_offset = 0.5

@onready var health: Health = $Health
@onready var knockback: Knockback = $Knockback
@onready var hit_detection: Area3D = $HitDetection
@onready var pivot: Node3D = $Pivot
@onready var body: MeshInstance3D = $Pivot/Body
@onready var collider: CollisionShape3D = $Collider

func _ready():
	hit_detection.area_entered.connect(_on_area_entered)
	health.damage_taken.connect(_on_damage_taken)

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
	drop_all_power()

func drop_all_power():
	if power_scene == null or power_drop_count <= 0:
		return
	for i in range(power_drop_count):
		drop_power()

func drop_power():
	var power = power_scene.instantiate()
	get_tree().root.add_child(power)
	var offset = Vector3.FORWARD.rotated(Vector3.UP, randf_range(0, PI)) * power_drop_offset
	power.global_position = global_position + offset