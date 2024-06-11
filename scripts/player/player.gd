class_name Player
extends CharacterBody3D

@export var default_speed = 15.0
@export var absorb_speed = 5.0
@export var deceleration = 3.0
@export var fall_acceleration = 10

@onready var absorb: Absorb = $Absorb

var speed = default_speed
var absorb_count = 0

func _ready():
	absorb.bullet_absorbed.connect(_on_absorb)
	absorb.absorb_started.connect(_on_absorb_started)
	absorb.absorb_ended.connect(_on_absorb_ended)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= fall_acceleration * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration)
		velocity.z = move_toward(velocity.z, 0, deceleration)

	move_and_slide()

func _on_absorb():
	absorb_count += 1
	print('current absorb count: %s' % absorb_count)

func _on_absorb_started():
	speed = absorb_speed

func _on_absorb_ended():
	speed = default_speed