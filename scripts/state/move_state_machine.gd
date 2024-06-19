class_name MoveStateMachine
extends StateMachine

var move_state: MoveState:
    get: return state as MoveState

var movement: Vector3:
    get: return move_state.movement
var can_aim: bool:
    get: return move_state.can_aim
var can_fire: bool:
    get: return move_state.can_fire
var can_absorb: bool:
    get: return move_state.can_absorb
var can_take_damage: bool:
    get: return move_state.can_take_damage
