class_name FireCooldownReward extends Reward

@export var fire_efficiency_increase := 0.5

func get_reward_type() -> RewardType:
    return RewardType.FireCooldown

func upgrade(player: Player):
    var old_cooldown := player.stats.get_fire_cooldown(1.0)
    player.stats.fire_cooldown_modifier += fire_efficiency_increase

    print("Fire cooldown decreased: ", old_cooldown, " -> ", player.stats.get_fire_cooldown(1.0))