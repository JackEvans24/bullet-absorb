class_name Player
extends CharacterBody3D

signal bullet_fired
signal absorb_state_changed(absorb_state: AbsorbState)
signal power_count_changed(count: float)
signal damage_taken
signal can_dash_changed(can_dash: bool)
signal died

enum AbsorbState {Started, Cancelled, Complete}

@export var stats: PlayerStats: set = update_stats

@onready var move_state: MoveStateMachine = $MoveState
@onready var health: Health = $Health
@onready var aim: PlayerAim = $Aim
@onready var dash: Dash = $Dash
@onready var absorb: Absorb = $Absorb
@onready var body: PlayerBody = $Pivot
@onready var camera_follow_point: Node3D = $Pivot/CameraFollowPoint
@onready var hit_detection: Area3D = $HitDetection
@onready var ground_detection: CollisionShape3D = $GroundDetection
@onready var animator: AnimationPlayer = $Animator

var power_count: float = 0.0

var current_health:
	get: return health.current_health

func _ready():
	update_stats(stats)

	died.connect(body._on_player_died)

	move_state.state_entered.connect(_on_move_state_entered)

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
	absorb.absorb_triggered.connect(_on_absorb_triggered)

	hit_detection.area_entered.connect(_on_hit)

	dash.initialise(move_state, body)

# TODO: Replace with powerups
func update_stats(player_stats: PlayerStats):
	stats = player_stats
	if aim:
		aim.stats = stats

	# health.initialise(stats.max_health)
	# aim.cooldown_modifier = stats.fire_cooldown_modifier
	# absorb.windup_modifier = stats.absorb_windup_modifier
	# absorb.destoy_area.scale = Vector3.ONE * stats.absorb_area
	# absorb.mesh.scale = Vector3.ONE * stats.absorb_area

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
	if power_count == stats.max_power:
		return
	power_count = min(stats.max_power, power_count + stats.power_conversion)
	update_power_count()

func _on_bullet_fired():
	power_count = max(0, power_count - stats.fire_power_consumption)
	update_power_count()
	bullet_fired.emit()

func update_power_count():
	power_count_changed.emit(power_count)
	aim.has_ammo = power_count >= stats.fire_power_consumption

func _on_hit(area: Area3D):
	health.take_damage(1.0, area)

func _on_slowdown_started():
	move_state.transition_to(MoveStateConstants.STATE_ABSORB)
	absorb_state_changed.emit(AbsorbState.Started)
	animator.speed_scale = absorb.windup_modifier / absorb.absorb_windup

func _on_slowdown_ended():
	move_state.transition_to(MoveStateConstants.STATE_RUN)
	absorb_state_changed.emit(AbsorbState.Cancelled)
	animator.speed_scale = 1.0

func _on_absorb_triggered():
	absorb_state_changed.emit(AbsorbState.Complete)
