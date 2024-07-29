class_name Bullet
extends Area3D

@export var speed = 5
@export var accuracy = 1.0 / 6.0

@onready var mesh: MeshInstance3D = $Mesh
@onready var collider: CollisionShape3D = $Collider
@onready var splash_particles: GPUParticles3D = $SplashParticles
@onready var drop_power: DropPower = $DropPower
@onready var absorb_handler: AbsorbHandler = $AbsorbHandler

var dead = false
var absorbed = false

func _ready():
	body_entered.connect(_on_body_entered)
	absorb_handler.absorb_triggered.connect(_on_absorb_handler_triggered)

func initialise(turret_basis: Basis):
	basis = turret_basis.orthonormalized()
	# add some random rotation to look direction
	rotate_y(randf_range( - PI * accuracy, PI * accuracy))

func _physics_process(_delta):
	if dead:
		return
	var forward = -global_transform.basis.z
	position += forward * speed * _delta

func _on_body_entered(body: Node3D):
	if absorbed:
		return

	if body.has_node("BulletHitHandler"):
		body.get_node("BulletHitHandler").trigger(self)

	call_deferred("handle_destruction")

func handle_destruction():
	dead = true
	collider.disabled = true
	mesh.visible = false

	splash_particles.restart()
	await splash_particles.finished

	call_deferred("queue_free")

func _on_absorb_handler_triggered():
	absorbed = true

	drop_power.drop_all_power()
	handle_destruction()