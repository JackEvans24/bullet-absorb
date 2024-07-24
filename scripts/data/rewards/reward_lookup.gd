class_name RewardLookup extends Resource

@export var lookup: Array[RewardMapping]

func find(reward_type: Reward.RewardType) -> Reward:
	var matching = lookup.filter(func(x): return x.reward_type == reward_type)
	if matching.is_empty():
		return null
	return matching[0].reward