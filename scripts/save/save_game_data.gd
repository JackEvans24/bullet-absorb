class_name SaveGameData

var saved_int: int = 1

func to_dictionary() -> Dictionary:
    var dict: Dictionary = {}

    for prop in get_property_list():
        if prop.usage == PROPERTY_USAGE_SCRIPT_VARIABLE:
            dict[prop.name] = self.get(prop.name)

    return dict

func read(dict: Dictionary):
    for prop in get_property_list():
        if prop.usage == PROPERTY_USAGE_SCRIPT_VARIABLE:
            set(prop.name, dict[prop.name])