class_name SaveGame
extends Node

var SAVE_FILE_PATH := "user://bullet_absorb.save"
var data := SaveGameData.new()

func save():
	var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	var serialised_data = JSON.stringify(data.to_dictionary())
	save_file.store_string(serialised_data)

func load():
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