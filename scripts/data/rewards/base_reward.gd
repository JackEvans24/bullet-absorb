class_name Reward extends Resource

enum RewardType {
    None,
    Health,
    MaxPower,
    PowerConversion,
    FireEfficiency,
    FireCooldown,
    AbsorbWindup,
    AbsorbArea
}

func get_reward_type() -> RewardType:
    return RewardType.None

func upgrade(_player: Player):
    printerr("Using base reward in game, use inherited class instead")