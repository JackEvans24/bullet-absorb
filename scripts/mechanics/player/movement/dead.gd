class_name DeadMoveState
extends MoveState

@export var deceleration: float = 180

func _init():
    can_aim = false
    can_fire = false
    can_absorb = false
    movement = Vector3.ZERO
