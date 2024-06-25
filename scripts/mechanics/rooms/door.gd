class_name Door extends StaticBody3D

@onready var collider: CollisionShape3D = $Collider

func set_closed(closed: bool):
	collider.disabled = !closed
	visible = closed
