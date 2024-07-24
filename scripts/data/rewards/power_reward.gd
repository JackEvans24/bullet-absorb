class_name PowerReward extends Reward

@export var power_increase := 3.0

func upgrade(player: Player):
    var old_power := player.stats.max_power
    player.stats.max_power += power_increase

    print("Max power increased: ", old_power, " -> ", player.stats.max_power)