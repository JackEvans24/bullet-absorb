class_name Health
extends Node

signal damage_taken(damage_taken: float)

@export var starting_health = 5.0
@export var recovery_time = 1.0

@onready var current_health = starting_health

var is_recovering = false

func take_damage(damage: float):
	if is_recovering:
		return
	is_recovering = true

	current_health = max(0.0, current_health - damage)
	damage_taken.emit(damage)

	await get_tree().create_timer(recovery_time).timeout
	is_recovering = false