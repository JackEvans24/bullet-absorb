class_name AbsorbWindupReward extends Reward

@export var efficiency_increase := 0.25

func upgrade(player: Player):
    var old_absorb_time := player.stats.absorb_windup
    var old_absorb_modifier := player.stats.absorb_windup_modifier

    player.stats.absorb_windup_modifier += efficiency_increase

    print("Absorb time decreased: %ss (%s) -> %ss (%s)" %
        [old_absorb_time, old_absorb_modifier, player.stats.absorb_windup, player.stats.absorb_windup_modifier])