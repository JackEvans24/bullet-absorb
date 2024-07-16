class_name PlayerAim
extends Node

signal bullet_fired

@export var cooldown = 0.05
@export var bullet_scene: PackedScene

@onready var controller_aim: ControllerAimDirection = $ControllerAim
@onready var mouse_aim: MouseAimDirection = $MouseAim
var aim_service: AimDirection

var pivot: Node3D
var aim_direction: Vector3 = Vector3.FORWARD

var can_aim = true
var can_fire = true
var is_firing = false
var has_ammo = false

func _ready():
	aim_service = mouse_aim

func initialise(body_pivot: Node3D):
	pivot = body_pivot
	mouse_aim.player = pivot

func _process(_delta: float):
	if not can_aim:
		return

	var direction = aim_service.get_aim_direction()

	if direction:
		aim_direction = direction

func _input(event: InputEvent):
	check_input_method(event)

	if can_fire and event.is_action_pressed("fire"):
		fire()

func check_input_method(event: InputEvent):
	if event is InputEventMouseMotion:
		aim_service = mouse_aim
	elif aim_service == controller_aim:
		return
	elif controller_aim.get_aim_direction().length() > 0.1:
		aim_service = controller_aim

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
