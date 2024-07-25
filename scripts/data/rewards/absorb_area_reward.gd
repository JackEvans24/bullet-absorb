class_name AbsorbAreaReward extends Reward

@export var area_scale_increase := 0.5

func get_reward_type() -> RewardType:
    return RewardType.AbsorbArea

func upgrade(player: Player):
    var old_scale := player.stats.absorb_area_scale
    player.stats.absorb_area_scale += area_scale_increase

    print("Absorb area increased: ", old_scale, " -> ", player.stats.absorb_area_scale)