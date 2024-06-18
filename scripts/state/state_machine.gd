class_name StateMachine
extends Node

signal state_changed(state_name: String)

@export var initial_state := NodePath()

@onready var state: State = get_node(initial_state)

func _ready():
	for child in get_children():
		child.state_machine = self

	state.enter()
	state_changed.emit(state.name)

func _process(delta):
	state.update(delta)

func transition_to(target_state_name: String):
	if not has_node(target_state_name):
		printerr("No move state found with name: %s" % target_state_name)
		return

	state.exit()
	state = get_node(target_state_name)
	state.enter()
	state_changed.emit(state.name)
