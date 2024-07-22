class_name Power
extends Node3D

@export var wall_check_distance := 0.3
@export var attraction_delay := 0.3
@export_flags_3d_physics var collision_layer

@onready var attraction_area = $PlayerAttractionArea
@onready var collision_area: Area3D = $PlayerCollisionArea
@onready var follow_body: FollowBody3D = $FollowBody
@onready var smooth_movement: SmoothMovement = $SmoothMovement
@onready var wall_check: RayCast3D = $WallCheck

var can_attract = false
var target: Node3D

func _ready():
	attraction_area.body_entered.connect(_on_body_entered)

	await get_tree().create_timer(attraction_delay).timeout
	can_attract = true

	collision_area.collision_layer = collision_layer

func _process(_delta):
	if target == null or not can_attract:
		return

	follow_body.target = target
	target = null
	smooth_movement.clear_target()
	wall_check.enabled = false

func _physics_process(_delta):
	if follow_body.target != null:
		translate(follow_body.movement)
		return

	if wall_check.is_colliding():
		smooth_movement.clear_target()
		wall_check.enabled = false

	translate(smooth_movement.movement)

func _on_body_entered(body: Node3D):
	if body.has_node("Pivot"):
		target = body.get_node("Pivot")
	else:
		target = body

func set_target_position(target_position: Vector3):
	var direction = target_position - global_position
	wall_check.target_position = direction.normalized() * wall_check_distance
	smooth_movement.set_target(target_position)