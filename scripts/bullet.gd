class_name Bullet extends Node3D

@export var speed = 5
@export var accuracy = 1.0 / 6.0

func initialise(start_position: Vector3, turret_basis: Basis):
	basis = turret_basis.orthonormalized()
	position = start_position

	# add some random rotation to look direction
	rotate_y(randf_range( - PI * accuracy, PI * accuracy))

func _physics_process(_delta):
	var forward = -global_transform.basis.z
	position += forward * speed * _delta

func _on_screen_exited():
	queue_free()

func absorb():
	call_deferred("queue_free")