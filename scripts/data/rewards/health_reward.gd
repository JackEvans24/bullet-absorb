class_name HealthReward extends Reward

@export var health_increase := 1

func upgrade(player: Player):
    var old_health := player.stats.max_health
    player.stats.max_health += health_increase
    player.health.initialise(player.stats.max_health)

    print("Health increased: ", old_health, " -> ", player.stats.max_health)