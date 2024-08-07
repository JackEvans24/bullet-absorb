class_name State
extends Node

var state_machine: StateMachine

var allowed_transitions: Array = []

func get_allowed_transitions() -> Array:
	return []

func _init():
	allowed_transitions = get_allowed_transitions()

func enter(_ctx: Dictionary={}):
	pass

func update(_delta: float):
	pass

func exit():
	pass
