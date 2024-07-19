class_name SaveGame
extends Node

@export var start_room_override: String

var SAVE_FILE_PATH := "user://bullet_absorb.save"
var data := SaveGameData.new()

func save():
	if not OS.has_feature(GameFeatures.SAVE_SYSTEM):
		return

	var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	var serialised_data = JSON.stringify(data.to_dictionary())
	save_file.store_string(serialised_data)

func load():
	if not OS.has_feature(GameFeatures.SAVE_SYSTEM):
		overwrite_start_room()
		return

	if not FileAccess.file_exists(SAVE_FILE_PATH):
		print("File not found")
		return

	var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)

	var json: JSON = JSON.new()
	var parse_result = json.parse(save_file.get_as_text())
	if parse_result != OK:
		print("JSON parse error: ", json.get_error_message())
		return

	data.read(json.data)

func overwrite_start_room():
	if not start_room_override:
		return
	if not data.completed_rooms.has(start_room_override):
		data.completed_rooms.push_back(start_room_override)
	data.current_room = start_room_override

func add_completed_room(room_id: String):
	if data.completed_rooms.has(room_id):
		printerr("Room %s already marked as completed" % room_id)
		return

	data.completed_rooms.push_back(room_id)
	data.current_room = room_id

	save()