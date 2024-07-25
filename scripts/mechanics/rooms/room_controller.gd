class_name RoomController extends Node

signal reward_collected(reward_type: Reward.RewardType)
signal doors_changed
signal room_completed(room_id: String)
signal room_reentered(room_id: String)

@export var room_item_lookup: RoomItemLookup
var reward_lookup: RewardLookup

var rooms: Dictionary

func initialise(data: SaveGameData):
	var children = get_children()
	for child in children:
		var room = child as Room

		if rooms.has(room.data.room_name):
			printerr("Duplicate room name found whilst processing ", room.name, ": ", room.data.room_name)
			continue

		room.room_item_lookup = room_item_lookup
		room.reward_lookup = reward_lookup

		room.doors_changed.connect(_on_room_doors_changed)
		room.reward_collected.connect(_on_reward_collected)
		room.room_completed.connect(_on_room_completed)
		room.room_reentered.connect(_on_room_reentered)

		if data.completed_rooms.has(room.data.room_name):
			room.set_room_complete()

		rooms[room.data.room_name] = room

func get_room(id: String) -> Room:
	if not rooms.has(id):
		printerr("Trying to retrieve room that doesn't exist: ", id)
		return null
	return rooms[id]

func _on_room_doors_changed():
	doors_changed.emit()

func _on_reward_collected(reward_type: Reward.RewardType):
	reward_collected.emit(reward_type)

func _on_room_completed(room_id: String):
	room_completed.emit(room_id)

func _on_room_reentered(room_id: String):
	room_reentered.emit(room_id)