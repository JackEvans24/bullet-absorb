class_name AbsorbOrb
extends Node3D

signal orb_absorbed
signal orb_destroyed

@export var absorb_from_ready := false

@onready var mesh: MeshInstance3D = $Mesh
@onready var absorb_handler: AbsorbHandler = $Collider/AbsorbHandler
@onready var animation: AnimationPlayer = $Animator
@onready var create_particles: GPUParticles3D = $CreateParticles
@onready var idle_particles: GPUParticles3D = $IdleParticles
@onready var death_particles: GPUParticles3D = $DeathParticles
@onready var sfx: SoundBank = $SoundBank

func _ready():
	if absorb_from_ready:
		set_absorb_handler()
	sfx.play("Drone")

func _on_start_animation_complete():
	if not absorb_from_ready:
		set_absorb_handler()
	animation.play("idle")

func set_absorb_handler():
	absorb_handler.absorb_triggered.connect(_on_absorb_triggered)

# TODO: REPLACE INSTANT DEATH WITH HEALTH
func _on_absorb_triggered():
	call_deferred("destroy")

func destroy():
	animation.stop()
	mesh.visible = false

	create_particles.emitting = false
	idle_particles.emitting = false

	sfx.stop("Drone")
	sfx.play("Splash")
	orb_absorbed.emit()

	death_particles.emitting = true
	await get_tree().create_timer(death_particles.lifetime).timeout

	orb_destroyed.emit()

	queue_free()
