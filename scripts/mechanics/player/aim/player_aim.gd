class_name PlayerAim
extends Node

signal bullet_fired

@export var pivot_ref: NodePath
@export var arm_cannon_ref: NodePath
@export var aim_point_ref: NodePath
@export var cooldown = 0.05
@export var bullet_scene: PackedScene
@export var fire_fail_particles_scene: PackedScene

@onready var controller_aim: ControllerAimDirection = $ControllerAim
@onready var mouse_aim: MouseAimDirection = $MouseAim
@onready var pivot: Node3D = get_node(pivot_ref)
@onready var arm_cannon: ArmCannon = get_node(arm_cannon_ref)
@onready var aim_point: Node3D = get_node(aim_point_ref)
var aim_service: AimDirection

var aim_direction: Vector3 = Vector3.FORWARD

var can_aim = true
var can_fire = true
var is_firing = false
var has_ammo = false

func _ready():
	aim_service = mouse_aim
	mouse_aim.player = pivot

func _process(_delta: float):
	if not can_aim:
		return

	arm_cannon.aim_towards(aim_point.global_position)

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
	if is_firing:
		return
	if not has_ammo:
		arm_cannon.trigger_fire_fail()
		return
	is_firing = true

	var tree = get_tree()
	var bullet = bullet_scene.instantiate()
	tree.root.add_child(bullet)

	arm_cannon.initialise_bullet(bullet)

	bullet_fired.emit()

	await tree.create_timer(cooldown).timeout
	is_firing = false

func _on_power_count_changed(power_count: int):
	has_ammo = power_count > 0
