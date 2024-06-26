class_name Room
extends Node3D

@export var config: RoomData

@onready var boundary: RoomBoundary = $Boundary
@onready var player_detection: Area3D = $PlayerDetection

func _ready():
	boundary.set_doors(config.doors)
	player_detection.body_entered.connect(_on_player_entered)

func _on_player_entered(_body: Node3D):
	player_detection.body_entered.disconnect(_on_player_entered)
	boundary.call_deferred("close_all_doors")
