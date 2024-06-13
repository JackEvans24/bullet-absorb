class_name Player
extends CharacterBody3D

signal absorb_count_changed(count: int)

@export var fall_acceleration = 10

@onready var pivot: Node3D = $Pivot
@onready var move: PlayerMovement = $Move
@onready var aim: PlayerAim = $Aim
@onready var absorb: Absorb = $Absorb

var absorb_count: int = 0

func _ready():
	aim.initialise(pivot)

	absorb.bullet_absorbed.connect(_on_absorb)
	absorb.slowdown_started.connect(_on_slowdown_started)
	absorb.slowdown_ended.connect(_on_slowdown_ended)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= fall_acceleration * delta

	velocity = move.movement
	pivot.look_at(pivot.global_position + aim.aim_direction)

	move_and_slide()

func _on_absorb():
	absorb_count += 1
	absorb_count_changed.emit(absorb_count)

func _on_slowdown_started():
	move.set_slower_speed()

func _on_slowdown_ended():
	move.set_default_speed()
