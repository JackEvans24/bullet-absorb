class_name RoomData extends Resource

@export_flags("NORTH", "SOUTH", "EAST", "WEST") var untouched_doors := 0
@export_flags("NORTH", "SOUTH", "EAST", "WEST") var completed_doors := 0
@export var waves: Array[RoomConfiguration]
@export var completed_room: RoomConfiguration
