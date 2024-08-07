extends Node

@export var reward_lookup: RewardLookup
@export var start_room_override: String

@onready var hud: Hud = $HUD
@onready var player: Player = $Player
@onready var rooms: RoomController = $World/Rooms
@onready var cameras: CameraController = $Cameras
@onready var hit_stop: HitStop = $HitStop
@onready var pause: PauseService = $Pause

var game_data: GameData

func _ready():
	SaveGame.start_room_override = start_room_override
	game_data = SaveGame.load()

	initialise_settings()
	initialise_rooms()
	initialise_player()

	cameras.target = player.camera_follow_point

	hud.update(player)
	hud._on_health_changed(player.current_health)

func initialise_settings():
	var settings_data = SaveSettings.load()


func initialise_rooms():
	rooms.reward_lookup = reward_lookup

	rooms.initialise(game_data)

	rooms.doors_changed.connect(_on_room_doors_changed)
	rooms.wall_destroyed.connect(_on_room_wall_destroyed)
	rooms.boss_entered.connect(_on_boss_entered)
	rooms.reward_collected.connect(_on_reward_collected)
	rooms.room_completed.connect(_on_room_completed)
	rooms.room_reentered.connect(_on_room_reentered)

func initialise_player():
	for reward_type in game_data.collected_rewards:
		enable_reward(reward_type)

	if game_data.current_room:
		var current_room = rooms.get_room(game_data.current_room)
		if current_room:
			player.global_position = current_room.global_position

	player.bullet_fired.connect(_on_bullet_fired)
	player.absorb_state_changed.connect(_on_absorb_state_changed)
	player.damage_taken.connect(_on_damage_taken)
	player.died.connect(_on_player_died)

	player.power_count_changed.connect(hud._on_power_count_changed)
	player.power_check_failed.connect(hud._on_power_check_failed)

func _on_damage_taken():
	hit_stop.freeze()
	cameras.add_impulse(ScreenShakeMapping.ScreenShakeId.Hurt)
	hud._on_health_changed(player.current_health)

func _on_player_died():
	hud._on_player_died()
	pause.is_game_over = true

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

func _on_room_wall_destroyed():
	cameras.add_impulse(ScreenShakeMapping.ScreenShakeId.Doors)

func _on_boss_entered(boss: Boss):
	hud.initialise_boss_ui(boss)

func _on_reward_collected(reward_type: Reward.RewardType):
	enable_reward(reward_type)

	hud.update(player)

	SaveGame.add_collected_reward(reward_type)
	game_data = SaveGame.save()

func enable_reward(reward_type: Reward.RewardType):
	var reward = reward_lookup.find(reward_type)
	if not reward:
		printerr("Unable to find reward for type: ", Reward.RewardType.keys()[reward_type])
		return
	reward.upgrade(player)

func _on_room_completed(room_id: String):
	SaveGame.add_completed_room(room_id)
	SaveGame.set_current_room(room_id)
	game_data = SaveGame.save()

func _on_room_reentered(room_id: String):
	SaveGame.set_current_room(room_id)
	game_data = SaveGame.save()
