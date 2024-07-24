class_name RewardPickup extends Node3D

signal reward_collected(reward_type: Reward.RewardType)

@export var reward: Reward.RewardType

@onready var orb: AbsorbOrb = $Orb

func _ready():
    orb.orb_destroyed.connect(_on_orb_destroyed)

func _on_orb_destroyed():
    reward_collected.emit(reward)
    call_deferred("queue_free")