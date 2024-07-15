class_name PowerOrb
extends Node3D

@export var power_count := 5

@onready var absorb_handler: AbsorbHandler = $AbsorbHandler
@onready var drop_power: DropPower = $DropPower

@onready var mesh: MeshInstance3D = $Mesh
@onready var animation: AnimationPlayer = $Animator
@onready var create_particles: GPUParticles3D = $CreateParticles
@onready var idle_particles: GPUParticles3D = $IdleParticles
@onready var death_particles: GPUParticles3D = $DeathParticles

func _ready():
	drop_power.power_drop_count = power_count

func _on_start_animation_complete():
	absorb_handler.absorb_triggered.connect(_on_absorb_triggered)

# TODO: REPLACE INSTANT DEATH WITH HEALTH
func _on_absorb_triggered():
	call_deferred("destroy")

# TODO: HOOK UP SCREEN SHAKE?
func destroy():
	drop_power.drop_all_power()

	animation.stop()
	mesh.visible = false

	create_particles.emitting = false
	idle_particles.emitting = false

	death_particles.emitting = true
	await get_tree().create_timer(death_particles.lifetime).timeout

	queue_free()
