class_name Door extends StaticBody3D

@onready var collider: CollisionShape3D = $Collider

func set_active(active: bool):
	collider.disabled = !active
	visible = active
