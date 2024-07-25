class_name FireEfficiencyReward extends Reward

@export var efficiency_increase := 0.5

func get_reward_type() -> RewardType:
    return RewardType.FireEfficiency

func upgrade(player: Player):
    var old_efficiency := player.stats.fire_power_consumption_modifier
    player.stats.fire_power_consumption_modifier += efficiency_increase

    print("Fire efficiency increased: ", old_efficiency, " -> ", player.stats.fire_power_consumption_modifier)