class_name FireCooldownReward extends Reward

@export var fire_efficiency_increase := 0.5

func upgrade(player: Player):
    var old_cooldown := player.stats.fire_cooldown_modifier
    player.stats.fire_cooldown_modifier += fire_efficiency_increase

    print("Health increased: ", old_cooldown, " -> ", player.stats.fire_cooldown_modifier)