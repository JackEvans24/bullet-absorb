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

@export var reward_type: RewardType
@export var pickup_texture: Texture2D

func upgrade(_player: Player):
    printerr("Using base reward in game, use inherited class instead")