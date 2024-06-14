class_name Knockback
extends Node

@export var knockback_time: float = 0.4
@export var knockback_power: float = 4

var knockback_direction = Vector3.ZERO
var knockback_id = 0

func set_knockback_direction(direction: Vector3):
	knockback_direction = direction.normalized() * knockback_power

	knockback_id += 1
	var stored_id = knockback_id

	await get_tree().create_timer(knockback_time).timeout

	if knockback_id != stored_id:
		return

	knockback_direction = Vector3.ZERO
	knockback_id = 0