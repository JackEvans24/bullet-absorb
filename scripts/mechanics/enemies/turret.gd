class_name Turret
extends Enemy

@onready var look_at_target: LookAtTarget = $LookAtTarget
@onready var fire: FireFromPoint = $Fire
@onready var fire_timer: Timer = $FireTimer

var target: Node3D:
	set(value): look_at_target.target = value;

func _ready():
	super()
	look_at_target.pivot = pivot
	fire.pivot = pivot
	fire_timer.timeout.connect(_on_fire_timeout)

func _on_fire_timeout():
	fire.fire()

func die():
	super()
	target = null
	fire_timer.stop()
