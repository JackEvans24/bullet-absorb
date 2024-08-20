class_name RoomData extends Resource

@export var room_name: String = "Room"
@export var is_hidden_room := false
@export var waves: Array[RoomConfiguration]
@export var boss_data: BossData
@export var reward: Reward.RewardType
