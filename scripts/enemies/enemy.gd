class_name Enemy
extends Node3D

@export var hurt_particles_scene: PackedScene

@onready var health: Health = $Health
@onready var hit_detection: Area3D = $HitDetection
@onready var pivot: Node3D = $Pivot
@onready var body: MeshInstance3D = $Pivot/Body

func _ready():
	hit_detection.area_entered.connect(_on_area_entered)
	health.damage_taken.connect(_on_damage_taken)

func _on_area_entered(_area: Area3D):
	health.take_damage(1.0)

func _on_damage_taken(damage_taken: float):
	if damage_taken > 0:
		add_hurt_particles()
	if health.current_health <= 0:
		die()

func add_hurt_particles():
	var hurt_particles = hurt_particles_scene.instantiate()
	add_child(hurt_particles)
	hurt_particles.position = pivot.position

func die():
	body.visible = false