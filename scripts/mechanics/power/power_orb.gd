class_name PowerOrb
extends Node3D

@export var power_count := 5

@onready var absorb_handler: AbsorbHandler = $AbsorbHandler
@onready var drop_power: DropPower = $DropPower

@onready var mesh: MeshInstance3D = $Mesh
@onready var idle_particles: GPUParticles3D = $IdleParticles
@onready var death_particles: GPUParticles3D = $DeathParticles

func _ready():
	drop_power.power_drop_count = power_count
	absorb_handler.absorb_triggered.connect(_on_absorb_triggered)

# TODO: REPLACE INSTANT DEATH WITH HEALTH
func _on_absorb_triggered():
	call_deferred("destroy")

func destroy():
	drop_power.drop_all_power()

	mesh.visible = false

	idle_particles.emitting = false

	death_particles.emitting = true
	await get_tree().create_timer(death_particles.lifetime).timeout

	queue_free()