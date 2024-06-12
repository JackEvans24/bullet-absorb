class_name Bullet extends Node3D

@export var speed = 5
@export var accuracy = 1.0 / 6.0
@export var illuminate_time = 0.2
@export var illuminate_range = 5

@export var power_scene: PackedScene

@onready var light: OmniLight3D = $BulletLight

func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(light, "omni_range", illuminate_range, illuminate_time)

func initialise(turret_basis: Basis):
	basis = turret_basis.orthonormalized()
	# add some random rotation to look direction
	rotate_y(randf_range( - PI * accuracy, PI * accuracy))

func _physics_process(_delta):
	var forward = -global_transform.basis.z
	position += forward * speed * _delta

func _on_screen_exited():
	queue_free()

func absorb():
	call_deferred("create_power")

func create_power():
	var power = power_scene.instantiate()
	power.global_position = global_position

	get_tree().root.add_child(power)

	queue_free()
