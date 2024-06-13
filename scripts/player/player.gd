class_name Player
extends CharacterBody3D

signal power_count_changed(count: int)
signal health_changed(current_health: float)

@export var fall_acceleration = 10

@onready var health: Health = $Health
@onready var move: PlayerMovement = $Move
@onready var aim: PlayerAim = $Aim
@onready var absorb: Absorb = $Absorb
@onready var body: PlayerBody = $Pivot
@onready var hit_detection: Area3D = $HitDetection

var power_count: int = 0

var current_health:
	get: return health.current_health

func _ready():
	power_count_changed.connect(aim._on_power_count_changed)

	health.damage_taken.connect(_on_damage_taken)
	health.recovery_changed.connect(body._on_recovery_changed)

	absorb.bullet_absorbed.connect(_on_absorb)
	absorb.slowdown_started.connect(_on_slowdown_started)
	absorb.slowdown_ended.connect(_on_slowdown_ended)

	aim.bullet_fired.connect(_on_bullet_fired)

	hit_detection.area_entered.connect(_on_hit)

	aim.initialise(body)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= fall_acceleration * delta

	velocity = move.movement
	body.look_at(body.global_position + aim.aim_direction)

	move_and_slide()

func _on_damage_taken(_damage_taken: float):
	health_changed.emit(current_health)

func _on_absorb():
	power_count += 1
	update_power_count()

func _on_bullet_fired():
	power_count = max(0, power_count - 1)
	update_power_count()

func update_power_count():
	power_count_changed.emit(power_count)

func _on_hit(_area: Area3D):
	health.take_damage(1.0)

func _on_slowdown_started():
	move.set_slower_speed()

func _on_slowdown_ended():
	move.set_default_speed()
