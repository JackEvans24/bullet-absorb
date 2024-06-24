class_name Wanderer
extends Enemy

@onready var move: BasicMovement = $Movement
@onready var look_at_target: LookAtTarget = $LookAtTarget
@onready var fire: FireFromPoint = $Fire

var target: Node3D:
	set(value): look_at_target.target = value;

func _ready():
	super()
	look_at_target.pivot = pivot
	fire.pivot = pivot

func _physics_process(_delta):
	velocity = move.movement
	move_and_slide()

func die():
	super()
	target = null
	fire.stop()
