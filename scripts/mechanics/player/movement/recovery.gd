class_name RecoveryMoveState
extends RunMoveState

@export var recovery_duration: float = 0.2

var direction: Vector3 = Vector3.ZERO

func enter(_ctx: Dictionary={}):
	do_recovery_timeout()

func do_recovery_timeout():
	await get_tree().create_timer(recovery_duration).timeout
	state_machine.transition_to(MoveStateConstants.STATE_RUN)
