class_name Health
extends Node

signal damage_taken(damage_taken: float, current_health: float)

@export var starting_health = 5.0

@onready var current_health = starting_health

func take_damage(damage: float):
	current_health = max(0.0, current_health - damage)
	damage_taken.emit(damage, current_health)