class_name Power
extends Node3D

@export var wall_check_distance := 0.3

@onready var attraction_area = $PlayerAttractionArea
@onready var follow_body: FollowBody3D = $FollowBody
@onready var smooth_movement: SmoothMovement = $SmoothMovement
@onready var wall_check: RayCast3D = $WallCheck

func _ready():
	attraction_area.body_entered.connect(_on_body_entered)

func _physics_process(_delta):
	if follow_body.target != null:
		translate(follow_body.movement)
		return

	if wall_check.is_colliding():
		smooth_movement.clear_target()
		wall_check.enabled = false

	translate(smooth_movement.movement)

func _on_body_entered(body: Node3D):
	follow_body.target = body
	smooth_movement.clear_target()
	wall_check.enabled = false

func set_target_position(target_position: Vector3):
	var direction = target_position - global_position
	wall_check.target_position = direction.normalized() * wall_check_distance
	smooth_movement.set_target(target_position)