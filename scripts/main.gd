extends Node

@export var reward_lookup: RewardLookup

@onready var hud: Hud = $HUD
@onready var player: Player = $Player
@onready var rooms: RoomController = $World/Rooms
@onready var cameras: CameraController = $Cameras
@onready var hit_stop: HitStop = $HitStop
@onready var save_game: SaveGame = $SaveGame

func _ready():
	save_game.load()

	initialise_rooms()
	initialise_player()

	cameras.target = player.camera_follow_point

	hud.update(player)
	hud._on_health_changed(player.current_health)

func initialise_rooms():
	rooms.reward_lookup = reward_lookup

	rooms.initialise(save_game.data)

	rooms.doors_changed.connect(_on_room_doors_changed)
	rooms.boss_entered.connect(_on_boss_entered)
	rooms.reward_collected.connect(_on_reward_collected)
	rooms.room_completed.connect(_on_room_completed)
	rooms.room_reentered.connect(_on_room_reentered)

func initialise_player():
	for reward_type in save_game.data.collected_rewards:
		enable_reward(reward_type)

	if save_game.data.current_room:
		var current_room = rooms.get_room(save_game.data.current_room)
		if current_room:
			player.global_position = current_room.global_position

	player.bullet_fired.connect(_on_bullet_fired)
	player.absorb_state_changed.connect(_on_absorb_state_changed)
	player.damage_taken.connect(_on_damage_taken)

	player.power_count_changed.connect(hud._on_power_count_changed)
	player.power_check_failed.connect(hud._on_power_check_failed)
	player.died.connect(hud._on_player_died)

func _input(event: InputEvent):
	if event.is_action_pressed("restart"):
		restart_game()

func restart_game():
	get_tree().call_group("bullet", "queue_free")
	get_tree().reload_current_scene()

func _on_damage_taken():
	hit_stop.freeze()
	cameras.add_impulse(ScreenShakeMapping.ScreenShakeId.Hurt)
	hud._on_health_changed(player.current_health)

func _on_bullet_fired():
	cameras.add_impulse(ScreenShakeMapping.ScreenShakeId.Fire)

func _on_absorb_state_changed(absorb_state: Player.AbsorbState):
	match absorb_state:
		Player.AbsorbState.Complete:
			cameras.add_impulse(ScreenShakeMapping.ScreenShakeId.Absorb)
		Player.AbsorbState.Started:
			cameras.add_impulse(ScreenShakeMapping.ScreenShakeId.AbsorbWindup)
		Player.AbsorbState.Cancelled:
			cameras.cancel_impulse(ScreenShakeMapping.ScreenShakeId.AbsorbWindup)

func _on_room_doors_changed():
	cameras.add_impulse(ScreenShakeMapping.ScreenShakeId.Doors)

func _on_boss_entered(boss: Boss):
	hud.initialise_boss_ui(boss)

func _on_reward_collected(reward_type: Reward.RewardType):
	enable_reward(reward_type)

	hud.update(player)

	save_game.add_collected_reward(reward_type)
	save_game.save()

func enable_reward(reward_type: Reward.RewardType):
	var reward = reward_lookup.find(reward_type)
	if not reward:
		printerr("Unable to find reward for type: ", Reward.RewardType.keys()[reward_type])
		return
	reward.upgrade(player)

func _on_room_completed(room_id: String):
	save_game.add_completed_room(room_id)
	save_game.set_current_room(room_id)
	save_game.save()

func _on_room_reentered(room_id: String):
	save_game.set_current_room(room_id)
	save_game.save()
