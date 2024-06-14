class_name Turret
extends Enemy

@export var bullet_scene: PackedScene

@onready var gun_mesh: MeshInstance3D = $Pivot/Gun
@onready var fire_point: Node3D = $Pivot/FirePoint
@onready var fire_timer: Timer = $FireTimer

var _target: Node3D = null;

func _ready():
	super()
	fire_timer.timeout.connect(_on_fire_timeout)

func set_target(target: Node3D):
	_target = target

func _process(_delta):
	if _target == null:
		return

	var target_position = _target.position
	target_position.y = position.y

	pivot.look_at(target_position)

func _on_fire_timeout():
	var bullet = bullet_scene.instantiate()

	bullet.position = to_local(fire_point.global_position)
	bullet.initialise(pivot.basis)

	add_child(bullet)

func die():
	super()
	gun_mesh.visible = false
	fire_timer.stop()
