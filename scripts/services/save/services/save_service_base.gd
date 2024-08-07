class_name SaveServiceBase
extends Node

@onready var data = get_blank_data()

func get_blank_data() -> SavedData:
    printerr("Blank data not initialised")
    return null

func get_file_path() -> String:
    printerr("Save file path not initialised for save class", name)
    return ""

func do_debug_overwrites():
    pass

func save() -> SavedData:
    if not has_save_system():
        return data

    var path = get_file_path()
    if not path:
        return data

    var save_file = FileAccess.open(get_file_path(), FileAccess.WRITE)
    var serialised_data = JSON.stringify(data.to_dictionary())
    save_file.store_string(serialised_data)

    return data

func load() -> SavedData:
    if not has_save_system():
       do_debug_overwrites()
       return data

    var path = get_file_path()
    if not path:
        return data

    if not FileAccess.file_exists(path):
        print("File not found (%s), creating new data" % name)
        return save()

    var save_file = FileAccess.open(path, FileAccess.READ)

    var json: JSON = JSON.new()
    var parse_result = json.parse(save_file.get_as_text())
    if parse_result != OK:
        print("JSON parse error: ", json.get_error_message())
        return

    data.read(json.data)

    return data

func has_save_system() -> bool:
    return OS.has_feature(GameFeatures.SAVE_SYSTEM)