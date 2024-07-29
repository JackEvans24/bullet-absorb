class_name Player
extends CharacterBody3D

signal bullet_fired
signal absorb_state_changed(absorb_state: AbsorbState)
signal power_count_changed(count: float)
signal power_check_failed
signal damage_taken
signal died

enum AbsorbState {Started, Cancelled, Complete}

@export var stats: PlayerStats

@onready var move_state: MoveStateMachine = $MoveState
@onready var health: Health = $Health
@onready var aim: PlayerAim = $Aim
@onready var dash: Dash = $Dash
@onready var absorb: Absorb = $Absorb
@onready var body: PlayerBody = $Pivot
@onready var camera_follow_point: Node3D = $Pivot/CameraFollowPoint
@onready var collider: CollisionShape3D = $Collider
@onready var bullet_handler: BulletHitHandler = $BulletHitHandler
@onready var animator: AnimationPlayer = $Animator

var power_count: float = 0.0

var current_health:
	get: return 0.0 if not health else health.current_health

func _ready():
	aim.stats = stats
	absorb.stats = stats

	died.connect(body._on_player_died)

	move_state.state_entered.connect(_on_move_state_entered)

	health.damage_taken.connect(_on_damage_taken)
	health.damage_taken.connect(body._on_damage_taken)
	health.invincibility_changed.connect(body._on_invincibility_changed)

	aim.bullet_fired.connect(_on_bullet_fired)
	aim.fire_failed.connect(_on_fire_failed)

	dash.dash_triggered.connect(_on_dash_triggered)
	dash.dash_failed.connect(_on_dash_failed)

	absorb.bullet_absorbed.connect(_on_absorb)
	absorb.slowdown_started.connect(_on_slowdown_started)
	absorb.slowdown_ended.connect(_on_slowdown_ended)
	absorb.absorb_triggered.connect(_on_absorb_triggered)

	bullet_handler.bullet_connected.connect(_on_bullet_connected)

	dash.initialise(move_state, body)

func _physics_process(_delta):
	velocity = move_state.movement
	body.current_movement = velocity

	body.look_at(body.global_position + aim.aim_direction)

	move_and_slide()

func _on_move_state_entered(state: MoveState):
	aim.can_aim = state.can_aim
	aim.can_fire = state.can_fire

	absorb.can_absorb = state.can_absorb
	if not state.can_absorb:
		absorb.end_windup()

	health.can_take_damage = state.can_take_damage

	if state.animation_trigger:
		animator.play(state.animation_trigger)

	body._on_move_state_changed(state)

func _on_dash_triggered(dash_direction: Vector3):
	power_count = max(0, power_count - stats.dash_power_consumption)
	update_power_count()

	body._on_dash_triggered(dash_direction)

	var ctx: Dictionary = {}
	ctx[MoveStateConstants.DASH_DIRECTION] = dash_direction
	move_state.transition_to(MoveStateConstants.STATE_DASH, ctx)

func _on_dash_failed():
	power_check_failed.emit()

func _on_damage_taken(_damage_taken: float, taken_from: Node3D):
	damage_taken.emit()

	if current_health <= 0:
		die()
	else:
		knockback(taken_from)

func die():
	move_state.transition_to(MoveStateConstants.STATE_DEAD)
	collider.set_deferred("disabled", true)
	died.emit()

func knockback(taken_from: Node3D):
	var direction = global_position - taken_from.global_position
	direction.y = 0

	var ctx: Dictionary = {}
	ctx[MoveStateConstants.HIT_DIRECTION] = direction
	move_state.transition_to(MoveStateConstants.STATE_KNOCKBACK, ctx)

func _on_absorb():
	if power_count == stats.max_power:
		return
	power_count = min(stats.max_power, power_count + stats.power_conversion)
	update_power_count()

func _on_bullet_fired():
	power_count = max(0, power_count - stats.fire_power_consumption)
	update_power_count()
	bullet_fired.emit()

func _on_fire_failed():
	power_check_failed.emit()

func update_power_count():
	power_count_changed.emit(power_count)
	aim.has_ammo = power_count >= stats.fire_power_consumption
	dash.has_dash_power = power_count >= stats.dash_power_consumption

func _on_bullet_connected(bullet: Node3D):
	health.take_damage(1.0, bullet)

func _on_slowdown_started():
	move_state.transition_to(MoveStateConstants.STATE_ABSORB)
	absorb_state_changed.emit(AbsorbState.Started)
	animator.speed_scale = stats.absorb_windup

func _on_slowdown_ended():
	move_state.transition_to(MoveStateConstants.STATE_RUN)
	absorb_state_changed.emit(AbsorbState.Cancelled)
	animator.speed_scale = 1.0

func _on_absorb_triggered():
	absorb_state_changed.emit(AbsorbState.Complete)
