class_name Room
extends Node3D

@export var config: RoomData
@export var enemy_scene: PackedScene

@onready var boundary: RoomBoundary = $Boundary
@onready var player_detection: Area3D = $PlayerDetection

var player: Node3D

func _ready():
	reset_room_state()
	player_detection.body_entered.connect(_on_player_entered)

func _on_player_entered(body: Node3D):
	if player != null:
		return
	player = body

	call_deferred("on_first_entry")

func on_first_entry():
	boundary.close_all_doors()

	var enemy = enemy_scene.instantiate() as Enemy
	add_child(enemy)
	enemy.position = config.enemy_position

	enemy.set_target(player)
	enemy.died.connect(_on_enemy_died)

func _on_enemy_died():
	call_deferred("reset_room_state")

func reset_room_state():
	boundary.set_doors(config.doors)
