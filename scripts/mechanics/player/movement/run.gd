class_name RunMoveState
extends MoveState

@export var speed: float = 15.0
@export var deceleration: float = 180

func update(delta: float):
    super(delta)

    var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
    var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()

    if direction:
        movement = direction * speed
    else:
        movement = movement.move_toward(Vector3.ZERO, deceleration * delta)
