class_name HealthReward extends Reward

@export var health_increase := 1

func get_reward_type() -> RewardType:
    return RewardType.Health

func upgrade(player: Player):
    var old_health := player.stats.max_health
    player.stats.max_health += health_increase
    player.health.initialise(player.stats.max_health)

    print("Health increased: ", old_health, " -> ", player.stats.max_health)