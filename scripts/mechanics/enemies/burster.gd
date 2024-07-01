class_name Burster
extends Enemy

@onready var move: BasicMovement = $Movement
@onready var fire: FireFromRing = $Fire
@onready var behaviour_timer: VariableTimer = $BehaviourTimer
@onready var animation: AnimationPlayer = $Animator
@onready var spawn_tube: SpawnTube = $Pivot/SpawnTube

func _ready():
	behaviour_timer.named_timeout.connect(_on_behaviour_timer_timeout)

func _on_intro_start():
	spawn_tube.play_animation()

func _on_intro_complete():
	call_deferred("set_hit_detection")
	spawn_tube.call_deferred("queue_free")
	behaviour_timer.restart()

func _physics_process(delta):
	super(delta)
	if knockback.knockback_direction.length():
		return
	velocity = move.movement
	move_and_slide()

func _on_behaviour_timer_timeout(timer_name: String):
	match timer_name.to_lower():
		"walk": move.set_new_movement()
		"windup": do_windup()
		"fire": fire.fire()
		_: move.stop()

func do_windup():
	move.stop()
	animation.play("fire")

func die():
	super()
	behaviour_timer.stop()
	move.stop()