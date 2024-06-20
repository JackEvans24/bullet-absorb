class_name Health
extends Node

signal damage_taken(damage_taken: float, taken_from: Node3D)

@export var starting_health = 5.0
@export var recovery_time = 0.6

@onready var current_health = starting_health

var has_invincibility = false
var can_take_damage = true

func take_damage(damage: float, taken_from: Node3D):
	if not can_take_damage or has_invincibility or current_health <= 0:
		return

	has_invincibility = true

	current_health = max(0.0, current_health - damage)
	damage_taken.emit(damage, taken_from)

	await get_tree().create_timer(recovery_time).timeout
	has_invincibility = false