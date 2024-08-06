class_name Power
extends Node3D

signal absorbed

@export var wall_check_distance := 0.3
@export var attraction_delay := 0.3
@export var trigger_power_handler := true
@onready var destroy_offset := 0.5

@onready var pivot: Node3D = $Pivot
@onready var attraction_area: Area3D = $PlayerAttractionArea
@onready var collision_area: Area3D = $PlayerCollisionArea
@onready var follow_body: FollowBody3D = $FollowBody
@onready var smooth_movement: SmoothMovement = $SmoothMovement
@onready var wall_check: RayCast3D = $WallCheck
@onready var sfx: SoundBankUncached = $SoundBank

var current_attraction_timer := 0.0
var can_attract = false
var target: Node3D
var dead := false

func _ready():
	attraction_area.body_entered.connect(_on_body_entered_attraction)

func _process(delta):
	if not can_attract:
		update_attraction_timer(delta)
		return

	if target == null:
		return

	follow_body.target = target
	target = null
	smooth_movement.clear_target()
	wall_check.enabled = false

func update_attraction_timer(delta: float):
	current_attraction_timer += delta
	if current_attraction_timer < attraction_delay:
		return

	can_attract = true
	collision_area.body_entered.connect(_on_body_entered_collision)

func _physics_process(_delta):
	if follow_body.target != null:
		translate(follow_body.movement)
		return

	if wall_check.is_colliding():
		smooth_movement.clear_target()
		wall_check.enabled = false

	translate(smooth_movement.movement)

func _on_body_entered_attraction(body: Node3D):
	if body.has_node("Pivot"):
		target = body.get_node("Pivot")
	else:
		target = body

func _on_body_entered_collision(body: Node3D):
	if dead:
		return
	if trigger_power_handler and body.has_node("PowerHitHandler"):
		body.get_node("PowerHitHandler").trigger(self)

	absorbed.emit()

	call_deferred("handle_destruction")

func handle_destruction():
	if dead:
		return
	dead = true

	pivot.visible = false
	sfx.play("Splash")

	await get_tree().create_timer(destroy_offset).timeout
	queue_free()

func set_target_position(target_position: Vector3):
	var direction = target_position - global_position
	wall_check.target_position = direction.normalized() * wall_check_distance
	smooth_movement.set_target(target_position)
