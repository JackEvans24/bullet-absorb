class_name Turret
extends Enemy

@onready var swivel: Node3D = $Pivot/TurretSwivel
@onready var look_at_target: LookAtTarget = $LookAtTarget
@onready var fire: FireFromPoint = $Fire
@onready var fire_timer: VariableTimer = $FireTimer

func _ready():
	look_at_target.pivot = swivel
	fire.pivot = swivel
	fire_timer.named_timeout.connect(_on_behaviour_timer_timeout)

	call_deferred("set_hit_detection")
	fire_timer.restart()

func set_target(target: Node3D):
	look_at_target.target = target

func _on_behaviour_timer_timeout(timer_name: String):
	match timer_name.to_lower():
		"fire": fire.fire()

func die():
	super()
	look_at_target.target = null
	fire_timer.stop()
