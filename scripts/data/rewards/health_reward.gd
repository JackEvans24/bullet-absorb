class_name HealthReward extends Reward

@export var health_increase := 1

func upgrade(player: Player):
    player.stats.max_health += health_increase
    player.health.initialise(player.stats.max_health)