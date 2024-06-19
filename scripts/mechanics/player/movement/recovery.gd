class_name RecoveryMoveState
extends RunMoveState

@export var recovery_duration: float = 0.2

var direction: Vector3 = Vector3.ZERO

func get_allowed_transitions():
	var transitions = [
		MoveStateConstants.STATE_RUN,
	]
	if can_absorb:
		transitions.push_back(MoveStateConstants.STATE_ABSORB)
	if can_take_damage:
		transitions.push_back(MoveStateConstants.STATE_DEAD)
		transitions.push_back(MoveStateConstants.STATE_KNOCKBACK)
	return transitions

func enter(_ctx: Dictionary={}):
	do_recovery_timeout()

func do_recovery_timeout():
	await get_tree().create_timer(recovery_duration).timeout
	state_machine.transition_to(MoveStateConstants.STATE_RUN)
