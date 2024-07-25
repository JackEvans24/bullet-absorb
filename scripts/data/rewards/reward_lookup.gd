class_name RewardLookup extends Resource

@export var rewards: Array[Reward]
var lookup: Dictionary

func initialise():
	for reward in rewards:
		lookup[reward.get_reward_type()] = reward

func find(reward_type: Reward.RewardType) -> Reward:
	if lookup.is_empty():
		initialise()

	if not lookup.has(reward_type):
		return null
	return lookup[reward_type]