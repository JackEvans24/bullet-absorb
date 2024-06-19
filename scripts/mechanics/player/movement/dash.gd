class_name DashMoveState
extends MoveState

@export var dash_speed: float = 20.0
@export var dash_duration: float = 0.2

var direction: Vector3 = Vector3.ZERO

func _init():
	can_fire = false
	can_absorb = false
	movement = Vector3.ZERO

func enter(ctx: Dictionary={}):
	direction = ctx[MoveStateConstants.DASH_DIRECTION]

	if direction == null:
		printerr('Unable to find dash direction')
		state_machine.transition_to(MoveStateConstants.STATE_RUN)
		return

	movement = direction.normalized() * dash_speed
	do_dash_timeout()

func do_dash_timeout():
	await get_tree().create_timer(dash_duration).timeout
	# TODO: transition to dash recovery state
	# TODO: add is_invincible property to move state
	state_machine.transition_to(MoveStateConstants.STATE_RUN)
