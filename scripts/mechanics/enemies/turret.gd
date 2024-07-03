class_name Turret
extends Enemy

@onready var swivel: Node3D = $Pivot/TurretSwivel
@onready var look_at_target: LookAtTarget = $LookAtTarget
@onready var fire: FireFromPoint = $Fire
@onready var fire_timer: Timer = $FireTimer

func _ready():
	look_at_target.pivot = swivel
	fire.pivot = swivel
	fire_timer.timeout.connect(fire.fire)

	call_deferred("set_hit_detection")
	fire_timer.restart()

func set_target(target: Node3D):
	look_at_target.target = target

func die():
	super()
	look_at_target.target = null
	fire_timer.stop()
