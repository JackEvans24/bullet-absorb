class_name RoomController extends Node

signal doors_changed

@export var room_item_lookup: RoomItemLookup

var rooms: Array[Room]

func _ready():
	var children = get_children()
	for child in children:
		var room = child as Room
		room.room_item_lookup = room_item_lookup
		room.doors_changed.connect(_on_room_doors_changed)
		rooms.push_back(child as Room)

func _on_room_doors_changed():
	doors_changed.emit()
