class_name RewardPickup extends Node3D

signal reward_collected(reward_type: Reward.RewardType)

@export var reward: Reward.RewardType

@onready var orb: AbsorbOrb = $Orb

func _ready():
    orb.orb_absorbed.connect(_on_orb_absorbed)
    orb.orb_destroyed.connect(_on_orb_destroyed)

func _on_orb_absorbed():
    reward_collected.emit(reward)

func _on_orb_destroyed():
    call_deferred("queue_free")