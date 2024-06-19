class_name Player
extends CharacterBody3D

signal power_count_changed(count: int)
signal damage_taken
signal died

@export var fall_acceleration = 10

@onready var health: Health = $Health
@onready var move_state: MoveStateMachine = $MoveState
@onready var aim: PlayerAim = $Aim
@onready var absorb: Absorb = $Absorb
@onready var body: PlayerBody = $Pivot
@onready var camera_follow_point: Node3D = $Pivot/CameraFollowPoint
@onready var hit_detection: Area3D = $HitDetection
@onready var ground_detection: CollisionShape3D = $GroundDetection

var power_count: int = 0

var current_health:
	get: return health.current_health

func _ready():
	power_count_changed.connect(aim._on_power_count_changed)
	died.connect(body._on_player_died)

	move_state.state_changed.connect(_on_move_state_changed)

	health.damage_taken.connect(_on_damage_taken)
	health.damage_taken.connect(body._on_damage_taken)

	absorb.bullet_absorbed.connect(_on_absorb)
	absorb.slowdown_started.connect(_on_slowdown_started)
	absorb.slowdown_ended.connect(_on_slowdown_ended)

	aim.bullet_fired.connect(_on_bullet_fired)

	hit_detection.area_entered.connect(_on_hit)

	aim.initialise(body)

func _physics_process(_delta):
	velocity = move_state.movement
	body.look_at(body.global_position + aim.aim_direction)

	move_and_slide()

func _process(_delta):
	if Input.is_action_just_pressed("dash"):
		dash()

func dash():
	var dash_direction = move_state.movement
	if dash_direction.length() < 0.01:
		dash_direction = camera_follow_point.global_position - body.global_position

	var ctx: Dictionary = {}
	ctx[MoveStateConstants.DASH_DIRECTION] = dash_direction
	move_state.transition_to(MoveStateConstants.STATE_DASH, ctx)

func _on_move_state_changed(_state_name: String):
	aim.can_aim = move_state.can_aim
	aim.can_fire = move_state.can_fire
	absorb.can_absorb = move_state.can_absorb
	health.can_take_damage = move_state.can_take_damage

func _on_damage_taken(_damage_taken: float, taken_from: Node3D):
	damage_taken.emit()
	absorb.end_windup()

	if current_health <= 0:
		die()
	else:
		knockback(taken_from)

func die():
	move_state.transition_to(MoveStateConstants.STATE_DEAD)
	ground_detection.set_deferred("disabled", true)
	died.emit()

func knockback(taken_from: Node3D):
	var direction = global_position - taken_from.global_position
	direction.y = 0

	var ctx: Dictionary = {}
	ctx[MoveStateConstants.HIT_DIRECTION] = direction
	move_state.transition_to(MoveStateConstants.STATE_KNOCKBACK, ctx)

func _on_absorb():
	power_count += 1
	update_power_count()

func _on_bullet_fired():
	power_count = max(0, power_count - 1)
	update_power_count()

func update_power_count():
	power_count_changed.emit(power_count)

func _on_hit(area: Area3D):
	health.take_damage(1.0, area)

func _on_slowdown_started():
	move_state.transition_to(MoveStateConstants.STATE_ABSORB)
	aim.can_fire = false

func _on_slowdown_ended():
	move_state.transition_to(MoveStateConstants.STATE_RUN)
	aim.can_fire = true
