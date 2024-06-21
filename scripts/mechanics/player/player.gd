class_name Player
extends CharacterBody3D

signal power_count_changed(count: int)
signal damage_taken
signal can_dash_changed(can_dash: bool)
signal died

@export var max_power = 20

@onready var move_state: MoveStateMachine = $MoveState
@onready var health: Health = $Health
@onready var aim: PlayerAim = $Aim
@onready var dash: Dash = $Dash
@onready var absorb: Absorb = $Absorb
@onready var body: PlayerBody = $Pivot
@onready var camera_follow_point: Node3D = $Pivot/CameraFollowPoint
@onready var hit_detection: Area3D = $HitDetection
@onready var ground_detection: CollisionShape3D = $GroundDetection

var power_count: int = 0

var current_health:
	get: return health.current_health
var max_health:
	get: return health.starting_health

func _ready():
	power_count_changed.connect(aim._on_power_count_changed)
	died.connect(body._on_player_died)

	move_state.state_changed.connect(_on_move_state_changed)
	move_state.state_changed.connect(body._on_move_state_changed)

	health.damage_taken.connect(_on_damage_taken)
	health.damage_taken.connect(body._on_damage_taken)
	health.invincibility_changed.connect(body._on_invincibility_changed)

	aim.bullet_fired.connect(_on_bullet_fired)

	dash.dash_triggered.connect(_on_dash_triggered)
	dash.dash_triggered.connect(body._on_dash_triggered)
	dash.can_dash_changed.connect(_on_can_dash_changed)

	absorb.bullet_absorbed.connect(_on_absorb)
	absorb.slowdown_started.connect(_on_slowdown_started)
	absorb.slowdown_ended.connect(_on_slowdown_ended)

	hit_detection.area_entered.connect(_on_hit)

	aim.initialise(body)
	dash.initialise(move_state, body)

func _physics_process(_delta):
	velocity = move_state.movement
	body.look_at(body.global_position + aim.aim_direction)

	move_and_slide()

func _on_move_state_changed(state: MoveState):
	aim.can_aim = state.can_aim
	aim.can_fire = state.can_fire

	absorb.can_absorb = state.can_absorb
	if not state.can_absorb:
		absorb.end_windup()

	health.can_take_damage = state.can_take_damage

func _on_dash_triggered(dash_direction: Vector3):
	var ctx: Dictionary = {}
	ctx[MoveStateConstants.DASH_DIRECTION] = dash_direction
	move_state.transition_to(MoveStateConstants.STATE_DASH, ctx)
	can_dash_changed.emit(false)

func _on_can_dash_changed(can_dash: bool):
	can_dash_changed.emit(can_dash)

func _on_damage_taken(_damage_taken: float, taken_from: Node3D):
	damage_taken.emit()

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
	if power_count == max_power:
		return
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
