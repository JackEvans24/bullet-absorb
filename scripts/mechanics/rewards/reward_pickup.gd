class_name RewardPickup extends Node3D

signal reward_collected(reward_type: Reward.RewardType)

var reward: Reward

@onready var orb: AbsorbOrb = $Orb

func _ready():
    orb.orb_absorbed.connect(_on_orb_absorbed)
    orb.orb_destroyed.connect(_on_orb_destroyed)

func _on_orb_absorbed():
    reward_collected.emit(reward.get_reward_type())

func _on_orb_destroyed():
    call_deferred("queue_free")