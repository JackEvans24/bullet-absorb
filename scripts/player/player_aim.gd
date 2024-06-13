class_name PlayerAim
extends Node

@export var bullet_scene: PackedScene

var pivot: Node3D
var aim_direction: Vector3 = Vector3.FORWARD

func initialise(body_pivot: Node3D):
	pivot = body_pivot

func _process(_delta: float):
	var input_dir = Input.get_vector("aim_left", "aim_right", "aim_forward", "aim_back")
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()

	if direction:
		aim_direction = direction

func _input(event: InputEvent):
	if not event.is_action_pressed("fire"):
		return
	fire()

func fire():
	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)

	bullet.global_position = pivot.global_position
	bullet.initialise(pivot.basis)
