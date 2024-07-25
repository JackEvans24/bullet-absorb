class_name PowerLimitReward extends Reward

@export var power_increase := 3.0

func get_reward_type() -> RewardType:
    return RewardType.MaxPower

func upgrade(player: Player):
    var old_power := player.stats.max_power
    player.stats.max_power += power_increase

    print("Max power increased: ", old_power, " -> ", player.stats.max_power)