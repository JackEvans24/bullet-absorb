class_name StateMachine
extends Node

signal state_entered(state: State)
signal state_exited(state: State)

@export var initial_state := NodePath()

@onready var state: State = get_node(initial_state)

func _ready():
	for child in get_children():
		child.state_machine = self

	state.enter()
	state_entered.emit(state)

func _process(delta):
	state.update(delta)

func transition_to(target_state_name: String, ctx: Dictionary={}):
	if not has_node(target_state_name):
		printerr("No move state found with name: %s" % target_state_name)
		return

	if not state.allowed_transitions.has(target_state_name):
		print("Failed to transition from state '%s' to state '%s': not allowed" % [state.name, target_state_name])
		return

	print("Transitioned from state '%s' to state '%s'" % [state.name, target_state_name])

	state.exit()
	state_exited.emit(state)
	state = get_node(target_state_name)
	state.enter(ctx)
	state_entered.emit(state)
