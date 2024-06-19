class_name KnockbackMoveState
extends MoveState

@export var knockback_speed: float = 20.0
@export var knockback_duration: float = 0.2

var direction: Vector3

func get_allowed_transitions():
    return [MoveStateConstants.STATE_KNOCKBACK_RECOVERY]

func enter(ctx: Dictionary={}):
    direction = ctx[MoveStateConstants.HIT_DIRECTION]

    if direction == null:
        printerr('Unable to find hit direction for knockback')
        state_machine.transition_to(MoveStateConstants.STATE_RUN)
        return

    movement = direction.normalized() * knockback_speed

    do_knockback_timeout()

func do_knockback_timeout():
    await get_tree().create_timer(knockback_duration).timeout
    state_machine.transition_to(MoveStateConstants.STATE_KNOCKBACK_RECOVERY)
