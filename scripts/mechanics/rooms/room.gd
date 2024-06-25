class_name Room
extends Node3D

@onready var player_detection: Area3D = $PlayerDetection

func _ready():
    player_detection.body_entered.connect(_on_player_entered)

func _on_player_entered(body: Node3D):
    print("PLAYER ENTERED: %s" % body.name)
    player_detection.body_entered.disconnect(_on_player_entered)
