class_name PlayerAim
extends Node

signal bullet_fired

@export var fire_point_ref: NodePath
@export var cooldown = 0.05
@export var bullet_scene: PackedScene
@export var fire_fail_particles_scene: PackedScene

@onready var controller_aim: ControllerAimDirection = $ControllerAim
@onready var mouse_aim: MouseAimDirection = $MouseAim
@onready var fire_point: Node3D = get_node(fire_point_ref)
var aim_service: AimDirection

var aim_direction: Vector3 = Vector3.FORWARD

var can_aim = true
var can_fire = true
var is_firing = false
var has_ammo = false

func _ready():
	aim_service = mouse_aim
	mouse_aim.player = fire_point

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
	if is_firing:
		return
	if not has_ammo:
		do_fire_failed()
		return
	is_firing = true

	var tree = get_tree()
	var bullet = bullet_scene.instantiate()
	tree.root.add_child(bullet)

	bullet.global_position = fire_point.global_position
	bullet.initialise(fire_point.global_basis)

	bullet_fired.emit()

	await tree.create_timer(cooldown).timeout
	is_firing = false

func do_fire_failed():
	var particles = fire_fail_particles_scene.instantiate()
	add_child(particles)
	particles.global_position = fire_point.global_position

func _on_power_count_changed(power_count: int):
	has_ammo = power_count > 0
