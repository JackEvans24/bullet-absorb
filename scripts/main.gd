extends Node

@onready var hud: Hud = $HUD
@onready var player: Player = $Player
@onready var cameras: CameraController = $Cameras
@onready var hit_stop: HitStop = $HitStop

func _ready():
	cameras.target = player.camera_follow_point

	player.damage_taken.connect(_on_damage_taken)
	player.power_count_changed.connect(hud._on_absorb_count_changed)
	player.can_dash_changed.connect(hud._on_can_dash_changed)
	player.died.connect(hud._on_player_died)

	hud.initialise_max_values(player.max_health, player.max_power)
	hud._on_health_changed(player.current_health)

func _input(event: InputEvent):
	if event.is_action_pressed("restart"):
		restart_game()

func restart_game():
	get_tree().call_group("bullet", "queue_free")
	get_tree().reload_current_scene()

func _on_damage_taken():
	hit_stop.freeze()
	cameras.add_impulse()
	hud._on_health_changed(player.current_health)
