extends Node

@onready var hud: Hud = $HUD
@onready var player: Player = $Player
@onready var turret = $Turret

var is_dead = false

func _ready():
	turret.set_target(player)

	player.damage_taken.connect(_on_damage_taken)
	player.died.connect(_on_player_died)
	player.power_count_changed.connect(hud._on_absorb_count_changed)

	hud._on_health_changed(player.current_health)

func _input(event: InputEvent):
	if is_dead and event.is_action_pressed("fire"):
		get_tree().call_group("bullet", "queue_free")
		get_tree().reload_current_scene()

func _on_damage_taken():
	hud._on_health_changed(player.current_health)

func _on_player_died():
	is_dead = true