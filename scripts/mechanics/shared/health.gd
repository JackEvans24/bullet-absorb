class_name Health
extends Node

signal damage_taken(damage_taken: float, taken_from: Node3D)
signal invincibility_changed(is_invincible: bool)

@export var starting_health = 5.0
@export var recovery_time = 0.6

@onready var current_health = starting_health

var is_invincible = false
var can_take_damage = true

func take_damage(damage: float, taken_from: Node3D):
	if not can_take_damage or is_invincible or current_health <= 0:
		return

	is_invincible = true
	invincibility_changed.emit(is_invincible)

	current_health = max(0.0, current_health - damage)
	damage_taken.emit(damage, taken_from)

	await get_tree().create_timer(recovery_time).timeout
	is_invincible = false
	invincibility_changed.emit(is_invincible)