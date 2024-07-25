class_name RewardLookup extends Resource

@export var rewards: Array[Reward]
var lookup: Dictionary

func initialise():
	for reward in rewards:
		if reward.reward_type == Reward.RewardType.None:
			printerr("Reward type is none for resource: ", reward.resource_name)
			continue

		lookup[reward.reward_type] = reward

func find(reward_type: Reward.RewardType) -> Reward:
	if lookup.is_empty():
		initialise()

	if not lookup.has(reward_type):
		return null
	return lookup[reward_type]