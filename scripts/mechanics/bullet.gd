class_name Bullet
extends Area3D

@export var speed = 5
@export var accuracy = 1.0 / 6.0

@onready var mesh: MeshInstance3D = $Mesh
@onready var collider: CollisionShape3D = $Collider
@onready var splash_particles: GPUParticles3D = $SplashParticles
@onready var on_screen_notifier: VisibleOnScreenNotifier3D = $OnScreenNotifier
@onready var drop_power: DropPower = $DropPower
@onready var absorb_handler: AbsorbHandler = $AbsorbHandler

var dead = false

func _ready():
	body_entered.connect(_on_body_entered)
	on_screen_notifier.screen_exited.connect(_on_screen_exited)
	absorb_handler.absorb_triggered.connect(handle_destruction_with_power)

func initialise(turret_basis: Basis):
	basis = turret_basis.orthonormalized()
	# add some random rotation to look direction
	rotate_y(randf_range( - PI * accuracy, PI * accuracy))

func _physics_process(_delta):
	if dead:
		return
	var forward = -global_transform.basis.z
	position += forward * speed * _delta

func _on_body_entered(_body: Node3D):
	call_deferred("handle_destruction")

func _on_screen_exited():
	queue_free()

func handle_destruction():
	dead = true
	collider.disabled = true
	mesh.visible = false

	splash_particles.restart()
	await splash_particles.finished

	call_deferred("queue_free")

func handle_destruction_with_power():
	drop_power.drop_all_power()
	handle_destruction()