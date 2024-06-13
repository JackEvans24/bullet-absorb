class_name PlayerAim
extends Node

signal bullet_fired

@export var cooldown = 0.05
@export var bullet_scene: PackedScene

var pivot: Node3D
var aim_direction: Vector3 = Vector3.FORWARD

var is_firing = false
var has_ammo = false

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
	if is_firing or not has_ammo:
		return
	is_firing = true

	var tree = get_tree()
	var bullet = bullet_scene.instantiate()
	tree.root.add_child(bullet)

	bullet.global_position = pivot.global_position
	bullet.initialise(pivot.basis)

	bullet_fired.emit()

	await tree.create_timer(cooldown).timeout
	is_firing = false

func _on_power_count_changed(power_count: int):
	has_ammo = power_count > 0