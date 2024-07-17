class_name RoomConfiguration extends Resource

@export var enemies: Array[RoomEnemy]
@export var items: Array[RoomItem]

func _init():
	enemies = []
	items = []
