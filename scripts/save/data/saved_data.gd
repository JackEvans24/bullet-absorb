class_name SavedData

func to_dictionary() -> Dictionary:
    var dict: Dictionary = {}
    for prop in get_property_list():
        if is_script_variable(prop):
            if prop.type == TYPE_OBJECT:
                dict[prop.name] = object_to_dictionary(get(prop.name))
            else:
                dict[prop.name] = get(prop.name)
    return dict

func object_to_dictionary(obj: Object) -> Dictionary:
    var dict: Dictionary = {}
    for prop in obj.get_property_list():
        if is_script_variable(prop):
            if prop.type == TYPE_OBJECT:
                dict[prop.name] = object_to_dictionary(obj.get(prop.name))
            else:
                dict[prop.name] = obj.get(prop.name)
    return dict

func read(dict: Dictionary):
    for prop in get_property_list():
        if is_script_variable(prop) and dict.has(prop.name):
            if prop.type == TYPE_OBJECT:
                var unpacked = unpack_dictionary(get(prop.name), dict[prop.name])
                set(prop.name, unpacked)
            else:
                set(prop.name, dict[prop.name])

func unpack_dictionary(obj: Object, dict: Dictionary) -> Object:
    for prop in obj.get_property_list():
        if is_script_variable(prop) and dict.has(prop.name):
            if prop.type == TYPE_OBJECT:
                var unpacked = unpack_dictionary(obj.get(prop.name), dict[prop.name])
                obj.set(prop.name, unpacked)
            else:
                obj.set(prop.name, dict[prop.name])
    return obj

func is_script_variable(prop: Dictionary):
    return prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE != 0