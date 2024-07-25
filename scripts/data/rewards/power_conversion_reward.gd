class_name PowerConversionReward extends Reward

@export var power_increase := 0.5

func get_reward_type() -> RewardType:
    return RewardType.PowerConversion

func upgrade(player: Player):
    var old_conversion := player.stats.power_conversion
    player.stats.power_conversion += power_increase

    print("Power conversion increased: ", old_conversion, " -> ", player.stats.power_conversion)