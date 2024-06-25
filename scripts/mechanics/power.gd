class_name Power
extends Node3D

@onready var attraction_area = $PlayerAttractionArea
@onready var follow_body: FollowBody3D = $FollowBody
@onready var smooth_movement: SmoothMovement = $SmoothMovement

var target_position: Vector3:
	set(value): smooth_movement.set_target(value)

func _ready():
	attraction_area.body_entered.connect(_on_body_entered)

func _physics_process(_delta):
	var movement = follow_body.movement if follow_body.target != null else smooth_movement.movement
	translate(movement)

func _on_body_entered(body: Node3D):
	follow_body.target = body
	smooth_movement.clear_target()
