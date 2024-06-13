class_name Health
extends Node

signal damage_taken(damage_taken: float)
signal recovery_changed(is_recovering: bool)

@export var starting_health = 5.0
@export var recovery_time = 1.0

@onready var current_health = starting_health

var is_recovering = false

func take_damage(damage: float):
	if is_recovering:
		return

	current_health = max(0.0, current_health - damage)
	damage_taken.emit(damage)

	recover()

func recover():
	if current_health <= 0:
		return

	is_recovering = true
	recovery_changed.emit(is_recovering)

	await get_tree().create_timer(recovery_time).timeout

	is_recovering = false
	recovery_changed.emit(is_recovering)