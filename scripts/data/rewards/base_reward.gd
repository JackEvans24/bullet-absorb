class_name Reward extends Resource

enum RewardType {
    None,
    Health,
    MaxPower,
    # PowerConversion,
    # FireConsumption,
    # FireCooldown,
    # AbsorbWindup,
    # AbsorbArea
}

func upgrade(_player: Player):
    printerr("Using base reward in game, use inherited class instead")