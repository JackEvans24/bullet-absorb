class_name Room
extends Node3D

@export var config: RoomData

@onready var boundary: RoomBoundary = $Boundary
@onready var player_detection: Area3D = $PlayerDetection

var has_previously_entered := false

func _ready():
	boundary.set_doors(config.doors)
	player_detection.body_entered.connect(_on_player_entered)

func _on_player_entered(_body: Node3D):
	if has_previously_entered:
		return
	has_previously_entered = true

	call_deferred("on_first_entry")

func on_first_entry():
	boundary.close_all_doors()