class_name MoveStateMachine
extends StateMachine

var move_state: MoveState:
    get: return state as MoveState

var movement: Vector3:
    get: return move_state.movement
