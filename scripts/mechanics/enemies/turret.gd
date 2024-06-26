class_name Turret
extends Enemy

@onready var look_at_target: LookAtTarget = $LookAtTarget
@onready var fire: FireFromPoint = $Fire
@onready var fire_timer: Timer = $FireTimer

func _ready():
	super()
	look_at_target.pivot = pivot
	fire.pivot = pivot
	fire_timer.timeout.connect(fire.fire)

func set_target(target: Node3D):
	look_at_target.target = target

func die():
	super()
	look_at_target.target = null
	fire_timer.stop()
