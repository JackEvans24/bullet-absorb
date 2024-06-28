class_name Room
extends Node3D

signal doors_changed

@export var active_config: RoomData
@export var inactive_config: RoomData
@export var completed_config: RoomData

@onready var boundary: RoomBoundary = $Boundary
@onready var player_detection: Area3D = $PlayerDetection

var player: Node3D
var enemy_count = 0

func _ready():
	set_room_configuration(inactive_config)
	player_detection.body_entered.connect(_on_player_entered)

func _on_player_entered(body: Node3D):
	if player != null:
		return
	player = body

	call_deferred("on_first_entry")

func on_first_entry():
	set_room_configuration(active_config)

func set_room_configuration(config: RoomData):
	var doors_set = set_doors(config)
	if doors_set:
		doors_changed.emit()

	if config.spawn_delay > 0.0:
		await get_tree().create_timer(config.spawn_delay).timeout

	for enemy_config in config.enemies:
		add_enemy(enemy_config)
		enemy_count += 1
	for item_config in config.items:
		add_item(item_config)

func add_enemy(enemy_config: RoomItem):
	var enemy = await add_item(enemy_config) as Enemy
	enemy.set_target(player)
	enemy.died.connect(_on_enemy_died)

func add_item(item_config: RoomItem) -> Node3D:
	if item_config.particles != null:
		add_particles(item_config.particles, item_config.position)

	if item_config.spawn_delay > 0:
		await get_tree().create_timer(item_config.spawn_delay).timeout

	var item = item_config.scene.instantiate() as Node3D
	add_child(item)
	item.position = item_config.position
	return item

func add_particles(particles_scene: PackedScene, particles_position: Vector3):
	var particles = particles_scene.instantiate() as GPUParticles3D
	add_child(particles)
	particles.position = particles_position

	particles.restart()
	await particles.finished
	particles.call_deferred("queue_free")

func _on_enemy_died():
	if enemy_count <= 0:
		printerr("ENEMY DIED CALLED WHEN ALL ENEMIES ARE DEAD")

	enemy_count -= 1
	if enemy_count == 0:
		call_deferred("on_room_complete")

func on_room_complete():
	set_room_configuration(completed_config)

func set_doors(config: RoomData) -> bool:
	if not boundary.doors_need_changing(config.doors):
		return false
	boundary.set_doors(config.doors)
	return true
