class_name RoomController extends Node

signal doors_changed
signal room_completed(room_id: String)

@export var room_item_lookup: RoomItemLookup

var rooms: Dictionary

func initialise(data: SaveGameData):
	var children = get_children()
	for child in children:
		var room = child as Room

		if rooms.has(room.data.room_name):
			printerr("Duplicate room name found whilst processing ", room.name, ": ", room.data.room_name)
			continue

		room.room_item_lookup = room_item_lookup
		room.doors_changed.connect(_on_room_doors_changed)
		room.room_completed.connect(_on_room_completed)

		if data.completed_rooms.has(room.data.room_name):
			room.set_room_complete()

		rooms[room.data.room_name] = room

func _on_room_doors_changed():
	doors_changed.emit()

func _on_room_completed(room_id: String):
	room_completed.emit(room_id)