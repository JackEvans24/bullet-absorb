class_name Health
extends Node

signal damage_taken(damage_taken: float, taken_from: Node3D)

@export var starting_health = 5.0

@onready var current_health = starting_health

var can_take_damage = true

func take_damage(damage: float, taken_from: Node3D):
	if not can_take_damage or current_health <= 0:
		return

	current_health = max(0.0, current_health - damage)
	damage_taken.emit(damage, taken_from)