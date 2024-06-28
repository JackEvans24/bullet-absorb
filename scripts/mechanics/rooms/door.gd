class_name Door extends StaticBody3D

@onready var collider: CollisionShape3D = $Collider
@onready var is_closed := !collider.disabled

func set_closed(closed: bool):
	is_closed = closed
	collider.disabled = !closed
	visible = closed
