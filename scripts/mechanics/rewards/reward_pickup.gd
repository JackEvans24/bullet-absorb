class_name RewardPickup extends Node3D

signal reward_collected(reward_type: Reward.RewardType)

@export var reward: Reward.RewardType

@onready var collider: Area3D = $Pivot/Collider

func _ready():
    collider.body_entered.connect(_on_body_entered)

func _on_body_entered(_body: Node3D):
    reward_collected.emit(reward)
    call_deferred("queue_free")