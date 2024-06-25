class_name Room
extends Node3D

@export_flags("FORWARD", "BACK", "LEFT", "RIGHT") var door_config := 0

@onready var boundary: RoomBoundary = $Boundary
@onready var player_detection: Area3D = $PlayerDetection

func _ready():
	boundary.set_doors(door_config)
	player_detection.body_entered.connect(_on_player_entered)

func _on_player_entered(body: Node3D):
	print("PLAYER ENTERED: %s" % body.name)
	player_detection.body_entered.disconnect(_on_player_entered)
