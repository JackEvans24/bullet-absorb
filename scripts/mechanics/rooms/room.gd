class_name Room
extends Node3D

signal doors_changed
signal reward_collected(reward_type: Reward.RewardType)
signal room_completed(room_id: String)
signal room_reentered(room_id: String)

@export var data: RoomData

@onready var boundary: RoomBoundary = $Boundary
@onready var player_detection: Area3D = $PlayerDetection

var room_item_lookup: RoomItemLookup

var player: Node3D
var enemy_count = 0
var wave_index = 0
var completed := false

func _ready():
	set_doors(data.untouched_doors)
	player_detection.body_entered.connect(_on_player_entered)

func _on_player_entered(body: Node3D):
	if completed:
		room_reentered.emit(data.room_name)

	if player != null:
		return
	player = body
	call_deferred("on_first_entry")

func on_first_entry():
	if completed:
		return
	if len(data.waves) <= 0:
		on_room_complete()
		return

	close_all_doors()
	set_room_configuration(data.waves[wave_index])

func set_room_configuration(config: RoomConfiguration):
	if config == null:
		return
	for enemy_config in config.enemies:
		add_enemy(enemy_config)
		enemy_count += 1
	for item_config in config.items:
		add_item(item_config)

func add_enemy(enemy_config: RoomItem):
	var enemy = await add_item(enemy_config) as Enemy
	if enemy == null:
		return
	enemy.set_target(player)
	enemy.died.connect(_on_enemy_died)

func add_item(item_config: RoomItem) -> Node3D:
	if item_config.delay > 0.0:
		await get_tree().create_timer(item_config.delay).timeout

	var item = room_item_lookup.build_from_config(item_config)
	if item == null:
		printerr("ITEM NOT FOUND: %s" % RoomItem.RoomItemType.keys()[item_config.item_type])
		return null

	add_child(item)
	return item

func _on_enemy_died():
	if enemy_count <= 0:
		printerr("ENEMY DIED CALLED WHEN ALL ENEMIES ARE DEAD")

	enemy_count -= 1
	if enemy_count == 0:
		call_deferred("on_wave_complete")

func on_wave_complete():
	wave_index += 1
	if wave_index < len(data.waves):
		set_room_configuration(data.waves[wave_index])
		return
	on_room_complete()

func on_room_complete():
	if data.reward:
		close_all_doors()
		create_reward()
	else:
		set_room_complete()

func create_reward():
	var config: RoomItem = RoomItem.new()
	config.item_type = RoomItem.RoomItemType.Reward

	var reward_pickup = await add_item(config) as RewardPickup
	reward_pickup.reward = data.reward
	reward_pickup.reward_collected.connect(_on_reward_collected)

func _on_reward_collected(reward_type: Reward.RewardType):
	reward_collected.emit(reward_type)
	call_deferred("set_room_complete")

func set_room_complete():
	set_doors(data.completed_doors)

	completed = true
	room_completed.emit(data.room_name)

func close_all_doors():
	set_doors(0)

func set_doors(doors: int):
	if not boundary.doors_need_changing(doors):
		return
	boundary.set_doors(doors)
	doors_changed.emit()
