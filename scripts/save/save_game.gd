class_name SaveGame
extends Node

var start_room_override: String

var SAVE_GAME_FILE_PATH := "user://bullet_absorb_game.save"

var game_data := GameData.new()

func save() -> GameData:
	if not has_save_system():
		return game_data

	var save_file = FileAccess.open(SAVE_GAME_FILE_PATH, FileAccess.WRITE)
	var serialised_data = JSON.stringify(game_data.to_dictionary())
	save_file.store_string(serialised_data)

	return game_data

func load() -> GameData:
	if not has_save_system():
		overwrite_start_room()
		return game_data

	if not FileAccess.file_exists(SAVE_GAME_FILE_PATH):
		print("File not found")
		return game_data

	var save_file = FileAccess.open(SAVE_GAME_FILE_PATH, FileAccess.READ)

	var json: JSON = JSON.new()
	var parse_result = json.parse(save_file.get_as_text())
	if parse_result != OK:
		print("JSON parse error: ", json.get_error_message())
		return

	game_data.read(json.data)

	return game_data

func overwrite_start_room():
	if not start_room_override:
		return
	if not game_data.completed_rooms.has(start_room_override):
		game_data.completed_rooms.push_back(start_room_override)
	game_data.current_room = start_room_override

func add_completed_room(room_id: String):
	if game_data.completed_rooms.has(room_id):
		printerr("Room %s already marked as completed" % room_id)
		return

	game_data.completed_rooms.push_back(room_id)

func set_current_room(room_id: String):
	game_data.current_room = room_id

func add_collected_reward(reward: Reward.RewardType):
	game_data.collected_rewards.push_back(reward)

func has_save_system() -> bool:
	return OS.has_feature(GameFeatures.SAVE_SYSTEM)