extends Node

@onready var hud: Hud = $HUD
@onready var player: Player = $Player
@onready var turret = $Turret

func _ready():
	turret.set_target(player)
	player.absorb_count_changed.connect(hud._on_absorb_count_changed)
