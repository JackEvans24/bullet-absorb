class_name SaveGameData

var completed_rooms: Array = []
var current_room: String

func to_dictionary() -> Dictionary:
    var dict: Dictionary = {}

    for prop in get_property_list():
        if prop.usage == PROPERTY_USAGE_SCRIPT_VARIABLE:
            dict[prop.name] = self.get(prop.name)

    return dict

func read(dict: Dictionary):
    for prop in get_property_list():
        if prop.usage == PROPERTY_USAGE_SCRIPT_VARIABLE and dict.has(prop.name):
            set(prop.name, dict[prop.name])