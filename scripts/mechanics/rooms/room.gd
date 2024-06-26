class_name Room
extends Node3D

@export var config: RoomData

@onready var boundary: RoomBoundary = $Boundary
@onready var player_detection: Area3D = $PlayerDetection

var player: Node3D
var enemy_count = 0

func _ready():
	print(config)
	reset_room_state()
	player_detection.body_entered.connect(_on_player_entered)

func _on_player_entered(body: Node3D):
	if player != null:
		return
	player = body

	call_deferred("on_first_entry")

func on_first_entry():
	if config.enemies.size() == 0:
		return

	boundary.close_all_doors()
	for enemy in config.enemies:
		add_enemy(enemy)
		enemy_count += 1

func add_enemy(enemy_config: RoomItem):
	var enemy = enemy_config.scene.instantiate() as Enemy
	add_child(enemy)
	enemy.position = enemy_config.position

	enemy.set_target(player)
	enemy.died.connect(_on_enemy_died)

func _on_enemy_died():
	if enemy_count <= 0:
		printerr("ENEMY DIED CALLED WHEN ALL ENEMIES ARE DEAD")

	enemy_count -= 1
	if enemy_count == 0:
		call_deferred("reset_room_state")

func reset_room_state():
	boundary.set_doors(config.doors)
