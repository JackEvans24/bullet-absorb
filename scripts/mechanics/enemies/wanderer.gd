class_name Wanderer
extends Enemy

@onready var move: BasicMovement = $Movement
@onready var walk_timer: VariableTimer = $WalkTimer
@onready var look_at_target: LookAtTarget = $LookAtTarget
@onready var fire: FireFromPoint = $Fire

var target: Node3D:
	set(value): look_at_target.target = value;

func _ready():
	super()

	look_at_target.pivot = pivot
	fire.pivot = pivot
	walk_timer.timeout.connect(move.toggle_movement)

func _physics_process(delta):
	super(delta)
	if knockback.knockback_direction.length():
		return
	velocity = move.movement
	move_and_slide()

func die():
	super()
	target = null
	fire.stop()
