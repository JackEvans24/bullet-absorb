class_name SaveGameService
extends SaveServiceBase

const SAVE_GAME_FILE_PATH := "user://bullet_absorb_game.save_game"

var start_room_override: String

var game_data: GameData:
    get: return data as GameData

func get_blank_data() -> SavedData:
    return GameData.new()

func get_file_path() -> String:
    return SAVE_GAME_FILE_PATH

func do_debug_overwrites():
    overwrite_start_room()

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