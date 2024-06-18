class_name MoveStateMachine
extends Node

signal state_changed(state_name: String)

@export var initial_state := NodePath()

@onready var state: MoveState = get_node(initial_state)

var movement: Vector3:
    get: return state.movement
var can_aim: bool:
    get: return state.can_aim
var can_fire: bool:
    get: return state.can_fire
var can_absorb: bool:
    get: return state.can_absorb

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