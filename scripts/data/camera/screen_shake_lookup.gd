class_name ScreenShakeLookup extends Resource

@export var lookup: Array[ScreenShakeMapping]

func get_profile(id: ScreenShakeMapping.ScreenShakeId) -> ScreenShakeProfile:
	var matching = lookup.filter(func(x): return x.id == id)
	if matching.is_empty():
		return null
	var mapping: ScreenShakeMapping = matching[0]
	return mapping.profile
