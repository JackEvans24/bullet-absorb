class_name Wanderer
extends Enemy

@onready var move: BasicMovement = $Movement
@onready var walk_timer: VariableTimer = $WalkTimer
@onready var look_at_target: LookAtTarget = $LookAtTarget
@onready var fire: FireFromPoint = $Fire

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

func set_target(target: Node3D):
	look_at_target.target = target

func die():
	super()
	look_at_target.target = null
	fire.stop()
	walk_timer.stop()
	move.stop()
