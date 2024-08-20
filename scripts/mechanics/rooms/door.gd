class_name Door extends StaticBody3D

@export var door_path: NodePath

@onready var door_mesh: Node3D = get_node(door_path)
@onready var collider: CollisionShape3D = $Collider
@onready var is_closed := !collider.disabled

func set_closed(closed: bool):
	is_closed = closed
	collider.disabled = !closed
	door_mesh.visible = closed
