class_name PowerLimitReward extends Reward

@export var power_increase := 5.0

func upgrade(player: Player):
    var old_current_power := player.power_count
    player.power_count += power_increase

    var old_max_power := player.stats.max_power
    player.stats.max_power += power_increase

    player.update_power_count()

    print("Current power increased: ", old_current_power, " -> ", player.power_count)
    print("Max power increased: ", old_max_power, " -> ", player.stats.max_power)