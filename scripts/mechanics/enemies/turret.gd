class_name Turret
extends Enemy

@onready var swivel: Node3D = $Pivot/TurretSwivel
@onready var look_at_target: LookAtTarget = $LookAtTarget
@onready var fire: FireFromPoint = $Fire
@onready var fire_timer: VariableTimer = $FireTimer
@onready var spawn_tube: SpawnTube = $Pivot/SpawnTube
@onready var animation: AnimationPlayer = $Animator
@onready var windup_particles: GPUParticles3D = $Pivot/TurretSwivel/WindupParticles

func _ready():
	look_at_target.pivot = swivel
	fire.pivot = swivel
	fire_timer.named_timeout.connect(_on_behaviour_timer_timeout)

func _on_intro_animation_start():
	spawn_tube.play_animation()

func _on_intro_animation_complete():
	call_deferred("set_hit_detection")
	spawn_tube.call_deferred("queue_free")
	fire_timer.restart()

func set_target(target: Node3D):
	look_at_target.target = target

func _on_behaviour_timer_timeout(timer_name: String):
	match timer_name.to_lower():
		"fire": do_fire()
		"windup": windup_particles.restart()

func do_fire():
	animation.play("fire")
	fire.fire()

func die():
	super()
	look_at_target.target = null
	fire_timer.stop()
