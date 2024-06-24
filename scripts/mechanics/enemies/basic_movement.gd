class_name BasicMovement
extends Node3D

@export var speed := 5.0
@export var wall_check_distance = 2.0

@onready var walk_timer: VariableTimer = $WalkTimer
@onready var wall_check: RayCast3D = $WallCheck

var is_walking := false
var movement := Vector3.ZERO

func _ready():
    walk_timer.timeout.connect(change_movement)

func _physics_process(_delta):
    if wall_check.is_colliding():
        set_new_movement()

func change_movement():
    if is_walking:
        stop()
    else:
        set_new_movement()
    is_walking = !is_walking

func set_new_movement():
    var direction = Vector3.FORWARD.rotated(Vector3.UP, randf_range(0.0, 360.0))
    movement = direction * speed

    wall_check.target_position = direction * wall_check_distance
    wall_check.enabled = true

func stop():
    movement = Vector3.ZERO
    wall_check.enabled = false