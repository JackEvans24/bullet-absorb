class_name SaveSettingsService
extends SaveServiceBase

const SAVE_SETTINGS_FILE_PATH := "user://bullet_absorb_settings.save"

var settings_data: SettingsData:
    get: return data as SettingsData

func get_blank_data() -> SavedData:
    return SettingsData.new()

func get_file_path() -> String:
    return SAVE_SETTINGS_FILE_PATH