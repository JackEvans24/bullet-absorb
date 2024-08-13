class_name Room
extends Node3D

signal doors_changed
signal wall_destroyed(room_id: String, linked_room: String)
signal boss_entered(boss: Boss)
signal reward_collected(reward_type: Reward.RewardType)
signal room_completed(room_id: String)

@export var data: RoomData

@export_group("Hidden room")
@export var destructible_wall: DestructibleWall
@export var linked_room_name: String

@onready var boundary: RoomBoundary = $Boundary
@onready var player_detection: Area3D = $PlayerDetection
@onready var sfx: SoundBank = $SoundBank

var room_item_lookup: RoomItemLookup
var reward_lookup: RewardLookup

var player: Node3D
var enemy_count = 0
var wave_index = 0
var initialised := false
var boss_created := false
var completed := false

func _ready():
	set_doors(data.untouched_doors)
	player_detection.body_entered.connect(_on_player_entered)
	initialised = true

func _on_player_entered(body: Node3D):
	if player != null:
		return
	player = body
	call_deferred("on_first_entry")

func on_first_entry():
	if completed:
		return

	wave_index = 0

	close_all_doors()
	do_room_step()

func do_next_room_step():
	wave_index += 1
	do_room_step()

func do_room_step():
	if wave_index < len(data.waves):
		set_room_configuration(data.waves[wave_index])
		return

	if data.boss_data and not boss_created:
		create_boss()
		return

	if data.reward:
		close_all_doors()
		create_reward()
		return

	set_room_complete()

func set_room_configuration(config: RoomConfiguration):
	if config == null:
		do_next_room_step()
		return
	if not config.enemies and not config.items:
		do_next_room_step()
		return

	enemy_count = 0

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
	if enemy_count > 0:
		return

	call_deferred("do_next_room_step")

func create_boss():
	var boss = data.boss_data.boss_scene.instantiate() as Enemy
	boss.initialise(data.boss_data.max_health, data.boss_data.power_count)

	add_child(boss)

	boss.set_target(player)
	boss.died.connect(_on_boss_died)

	boss_created = true

	boss_entered.emit(boss)

func _on_boss_died():
	call_deferred("do_next_room_step")

func create_reward():
	var config: RoomItem = RoomItem.new()
	config.item_type = RoomItem.RoomItemType.Reward

	var reward_data = reward_lookup.find(data.reward)
	if not reward_data:
		printerr("Unable to find reward (%s) in lookup" % Reward.RewardType.keys()[data.reward])
		return

	var reward_pickup = room_item_lookup.build_from_config(config) as RewardPickup
	reward_pickup.reward = reward_data
	reward_pickup.reward_collected.connect(_on_reward_collected)

	add_child(reward_pickup)

func _on_reward_collected(reward_type: Reward.RewardType):
	reward_collected.emit(reward_type)
	call_deferred("set_room_complete")

func set_room_complete(quiet: bool = false):
	set_doors(data.completed_doors, quiet)

	handle_destructible_wall()

	completed = true
	room_completed.emit(data.room_name)

func handle_destructible_wall():
	if not destructible_wall:
		return

	destructible_wall.wall_destroyed.connect(_on_wall_destroyed)
	destructible_wall.mark_ready_to_destroy()

func quiet_destroy_wall():
	destructible_wall.quiet_destroy()

func _on_wall_destroyed():
	wall_destroyed.emit(data.room_name, linked_room_name)

func close_all_doors():
	set_doors(0)

func set_doors(doors: int, quiet: bool = false):
	if not boundary.doors_need_changing(doors):
		return
	boundary.set_doors(doors)

	if quiet:
		return

	doors_changed.emit()
	if initialised:
		sfx.play("Doors")
