class_name RoomData extends Resource

@export_flags("FORWARD", "BACK", "LEFT", "RIGHT") var doors := 0
@export var enemies: Array[RoomItem]
@export var items: Array[RoomItem]
