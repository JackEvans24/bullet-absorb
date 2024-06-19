class_name DeadMoveState
extends MoveState

@export var deceleration: float = 180

func _init():
    super()
    movement = Vector3.ZERO
