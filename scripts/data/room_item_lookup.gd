class_name RoomItemLookup extends Resource

@export var lookup: Array[RoomItemMapping]

func build_from_config(item_config: RoomItem) -> Node3D:
	var matching = lookup.filter(func(x): return x.item_type == item_config.item_type)
	if matching.is_empty():
		return null
	var build_config: RoomItemMapping = matching[0]
	
	var item = build_config.scene.instantiate()
	item.position = item_config.position
	
	if build_config.is_enemy:
		var enemy = item as Enemy
		enemy.initialise(build_config.health, build_config.power_count)
	
	return item
