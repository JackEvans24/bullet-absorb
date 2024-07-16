class_name RoomItemLookup extends Resource

@export var lookup: Array[RoomItemMapping]

func get_matching(key: RoomItem.RoomItemType) -> PackedScene:
	var matching = lookup.filter(func(x): return x.item_type == key)
	if matching.is_empty():
		return null

	return matching[0].scene
