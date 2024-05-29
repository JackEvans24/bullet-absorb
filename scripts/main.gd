extends Node

@onready var player: Player = $Player
@onready var turret = $Turret

func _ready():
	turret.set_target(player)
