extends Node3D

@export var bullet_scene: PackedScene

@onready var pivot: Node3D = $Pivot
@onready var fire_point: Node3D = $Pivot/FirePoint

var _target: Node3D = null;

func set_target(target: Node3D):
	_target = target

func _process(_delta):
	if _target == null:
		return

	var target_position = _target.position
	target_position.y = position.y

	pivot.look_at(target_position)

func _on_fire():
	var bullet = bullet_scene.instantiate()

	bullet.position = to_local(fire_point.global_position)
	bullet.initialise(pivot.basis)

	add_child(bullet)
