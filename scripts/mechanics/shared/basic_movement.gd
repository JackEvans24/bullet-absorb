class_name BasicMovement
extends Node3D

@export var speed := 5.0
@export var drift_max := 2.0
@export var drift_change := 0.3
@export var wall_check_distance := 2.0

@onready var wall_check: RayCast3D = $WallCheck
@onready var noise = FastNoiseLite.new()

var is_walking := false
var movement := Vector3.ZERO
var noise_y := 0.0

func toggle_movement():
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

    noise_y = 0
    noise.seed = randi_range(0, 99999)

func update_wall_check_position():
    wall_check.target_position = movement.normalized() * wall_check_distance

func stop():
    movement = Vector3.ZERO
    wall_check.enabled = false

func _physics_process(_delta):
    if wall_check.is_colliding():
        movement = movement.bounce(wall_check.get_collision_normal().normalized())
        update_wall_check_position()
    if is_walking:
        handle_drift(_delta)

func handle_drift(delta: float):
    if drift_max == 0:
        return

    noise_y += drift_change
    var noise_output = noise.get_noise_2d(noise.seed, noise_y)
    movement = movement.rotated(Vector3.UP, noise_output * drift_max * delta)

    update_wall_check_position()
