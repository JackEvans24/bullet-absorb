@tool

class_name RoomConfigEditor
extends Node3D

@export var room_reference: NodePath

@export_group("Enemies")
@export var room_item: RoomItem
@export var delay: float
@export var add_enemy: bool = false: set = add_enemy_to_current_wave
@export var add_item: bool = false: set = add_item_to_current_wave

@export_group("Current wave")
@export var config: RoomConfiguration
@export var finalise_wave: bool = false: set = add_wave_to_config
@export var set_completed_config: bool = false: set = add_as_completed_config
@export var clear_wave: bool = false: set = clear_current_config

func add_enemy_to_current_wave(_value: bool):
	if not Engine.is_editor_hint():
		return

	var new_enemy: RoomItem = get_room_item_copy()
	config.enemies.push_back(new_enemy)

func add_item_to_current_wave(_value: bool):
	if not Engine.is_editor_hint():
		return

	var new_item: RoomItem = get_room_item_copy()
	config.items.push_back(new_item)

func get_room_item_copy():
	if room_item == null:
		printerr("ROOM ITEM NOT SELECTED")
		return

	if config == null:
		config = RoomConfiguration.new()

	var new_room_item: RoomItem = room_item.duplicate()
	new_room_item.position = position
	new_room_item.delay = delay
	return new_room_item

func add_wave_to_config(_value: bool):
	if room_reference == null:
		printerr("NO ROOM REFERENCE SET")
		return
	var room: Room = get_node(room_reference)
	if room == null or not room is Room:
		printerr("ROOM IS NOT OF TYPE ROOM")
		return

	if config == null:
		printerr("CONFIG NOT DEFINED")
		return
	if len(config.enemies) <= 0:
		printerr("CONFIG HAS NO ENEMIES")
		return

	room.data.waves.push_back(config)

func add_as_completed_config(_value: bool):
	if room_reference == null:
		printerr("NO ROOM REFERENCE SET")
		return
	var room: Room = get_node(room_reference)
	if room == null or not room is Room:
		printerr("ROOM IS NOT OF TYPE ROOM")
		return

	if config == null:
		return
	if len(config.items) <= 0:
		printerr("CONFIG HAS NO ITEMS")
		return

	room.data.completed_room = config

func clear_current_config(_value: bool):
	config = null
