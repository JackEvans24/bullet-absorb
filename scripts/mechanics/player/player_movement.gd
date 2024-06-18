class_name PlayerMovement
extends Node

@export var movement_deadzone = 0.05
@export var default_speed = 15.0
@export var slower_speed = 5.0
@export var deceleration = 3.0

var speed = default_speed

var movement: Vector3 = Vector3.ZERO
var can_move: bool = true

# Called when the node enters the scene tree for the first time.
func _process(delta: float):
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()

	if can_move and direction:
		movement = direction * speed
	else:
		movement = movement.move_toward(Vector3.ZERO, deceleration * delta)

func set_default_speed():
	speed = default_speed

func set_slower_speed():
	speed = slower_speed