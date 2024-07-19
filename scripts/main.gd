extends Node

@export var doors_changed_screen_shake_profile: ScreenShakeProfile
@export var fire_screen_shake_profile: ScreenShakeProfile
@export var absorb_screen_shake_profile: ScreenShakeProfile

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

	hud.initialise_max_values(player.max_health, player.max_power)
	hud._on_health_changed(player.current_health)

func initialise_rooms():
	rooms.initialise(save_game.data)
	rooms.doors_changed.connect(_on_room_doors_changed)
	rooms.room_completed.connect(_on_room_completed)

func initialise_player():
	var current_room = rooms.get_room(save_game.data.current_room)
	if current_room:
		player.global_position = current_room.global_position

	player.damage_taken.connect(_on_damage_taken)
	player.bullet_fired.connect(_on_bullet_fired)
	player.absorb_state_changed.connect(_on_absorb_state_changed)
	player.power_count_changed.connect(hud._on_absorb_count_changed)
	player.can_dash_changed.connect(hud._on_can_dash_changed)
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

func _on_room_completed(room_id: String):
	save_game.add_completed_room(room_id)
