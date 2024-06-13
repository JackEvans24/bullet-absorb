class_name Bullet extends Node3D

@export var speed = 5
@export var accuracy = 1.0 / 6.0

@export var power_scene: PackedScene

func initialise(turret_basis: Basis):
	basis = turret_basis.orthonormalized()
	# add some random rotation to look direction
	rotate_y(randf_range( - PI * accuracy, PI * accuracy))

func _physics_process(_delta):
	var forward = -global_transform.basis.z
	position += forward * speed * _delta

func _on_screen_exited():
	queue_free()

func destroy():
	call_deferred("handle_destruction")

func handle_destruction():
	drop_power()
	queue_free()

func drop_power():
	if power_scene == null:
		return

	var power = power_scene.instantiate()
	get_tree().root.add_child(power)
	power.global_position = global_position
