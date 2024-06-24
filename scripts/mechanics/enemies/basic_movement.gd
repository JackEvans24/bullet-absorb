class_name BasicMovement
extends Node

@export var speed := 5.0

@onready var walk_timer: VariableTimer = $WalkTimer

var is_walking := false
var movement := Vector3.ZERO

func _ready():
    walk_timer.timeout.connect(change_movement)

func change_movement():
    if is_walking:
        stop()
    else:
        set_new_movement()
    is_walking = !is_walking

func set_new_movement():
    movement = Vector3.FORWARD.rotated(Vector3.UP, randf_range(0.0, 360.0)) * speed

func stop():
    movement = Vector3.ZERO