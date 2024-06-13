class_name PlayerAim
extends Node

@export var cooldown = 0.05
@export var bullet_scene: PackedScene

var pivot: Node3D
var aim_direction: Vector3 = Vector3.FORWARD

var is_doing_cooldown = false

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
	if is_doing_cooldown:
		return
	is_doing_cooldown = true

	var tree = get_tree()
	var bullet = bullet_scene.instantiate()
	tree.root.add_child(bullet)

	bullet.global_position = pivot.global_position
	bullet.initialise(pivot.basis)

	await tree.create_timer(cooldown).timeout
	is_doing_cooldown = false