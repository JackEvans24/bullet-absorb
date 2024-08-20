@tool

class_name RoomGenerator
extends EditorScript

const WALL_ITEM := 0
const FLOOR_ITEM := 1
const INVISIBLE_WALL_ITEM := 3

enum DoorDirection {North = 0, East = 1, South = 2, West = 3}

const ROT_SOUTH := 0
const ROT_NORTH := 10
const ROT_EAST := 22
const ROT_WEST := 16

const FLOOR_OFFSET = Vector3(0, -1, 0)

var DOOR_GRID_OFFSETS: Dictionary

var doorway_rotations: Array[int] = [ROT_SOUTH, ROT_EAST, ROT_NORTH, ROT_WEST]

@export_group("Size")
@export var depth := 8
@export var width := 12

@export_group("Detection")
@export var detection_offset := 4.0
@export var detection_height := 2.0

@export_group("Doors")
@export var door_scene: PackedScene = preload("res://prefabs/room_items/door.tscn")
@export_flags("NORTH", "SOUTH", "EAST", "WEST") var start_doors := 2
@export_flags("NORTH", "SOUTH", "EAST", "WEST") var end_doors := 15
@export var door_offsets: Vector4 = Vector4(0, 0, 0, 0)

var scene: Node
var room: Node3D
var grid: GridMap
var boundary: RoomBoundary

func _run():
	if not Engine.is_editor_hint():
		return
	if not DOOR_GRID_OFFSETS:
		build_door_offset_dict()
	generate_room()

func build_door_offset_dict():
	DOOR_GRID_OFFSETS[DoorDirection.North] = Vector3(0, 0, 1)
	DOOR_GRID_OFFSETS[DoorDirection.East] = Vector3(0, 0, 0)
	DOOR_GRID_OFFSETS[DoorDirection.South] = Vector3(0, 0, 0)
	DOOR_GRID_OFFSETS[DoorDirection.West] = Vector3(1, 0, 0)

func generate_room():
	# Set references
	scene = get_scene()
	if not scene.name == "RoomGenerator":
		printerr("NOT IN ROOM GENERATOR SCENE")
		return
	room = scene.get_node("Room")
	grid = scene.get_node("Room/Grid")
	boundary = scene.get_node("Room/Boundary")

	# Clear existing grid
	remove_children_from(grid)
	remove_children_from(boundary)
	grid.clear()

	# Build walls
	var pos := Vector3(0, 0, 0)
	for z in range(-depth, depth):
		for x in range(-width, width):
			pos.x = x
			pos.z = z
			if x == -width:
				grid.set_cell_item(pos, INVISIBLE_WALL_ITEM, ROT_EAST)
			elif x == width - 1:
				grid.set_cell_item(pos, INVISIBLE_WALL_ITEM, ROT_WEST)
			elif z == -depth:
				grid.set_cell_item(pos, WALL_ITEM, ROT_NORTH)
			elif z == depth - 1:
				grid.set_cell_item(pos, INVISIBLE_WALL_ITEM, ROT_SOUTH)
			else:
				grid.set_cell_item(pos + FLOOR_OFFSET, FLOOR_ITEM)

	# Set start_doors
	if (start_doors & 1 != 0) or (end_doors & 1 != 0):
		add_door(Vector3(0, 0, -depth), DoorDirection.North, door_offsets.x)
	if (start_doors & 2 != 0) or (end_doors & 2 != 0):
		add_door(Vector3(0.0, 0.0, depth - 1.0), DoorDirection.South, door_offsets.y)
	if (start_doors & 4 != 0) or (end_doors & 4 != 0):
		add_door(Vector3(width - 1, 0, 0), DoorDirection.East, door_offsets.z)
	if (start_doors & 8 != 0) or (end_doors & 8 != 0):
		add_door(Vector3(-width, 0, 0), DoorDirection.West, door_offsets.w)

	# Set player detection space
	var detection_shape: CollisionShape3D = scene.get_node("Room/PlayerDetection/Shape")
	var box: BoxShape3D = detection_shape.shape
	box.size = Vector3((width * 2) - detection_offset, detection_height, (depth * 2) - detection_offset)

	# Set data
	room.data = RoomData.new()
	room.data.untouched_doors = start_doors
	room.data.completed_doors = end_doors

func remove_children_from(removal_node: Node):
	for child in removal_node.get_children():
		removal_node.remove_child(child)
		child.queue_free()

func clear_grid(_value: bool):
	grid.clear()

func add_door(door_position: Vector3, door_rotation_index: DoorDirection, offset: float) -> Node3D:
	var is_horizontal_door = door_rotation_index % 2 == 0
	var grid_direction := Vector3.RIGHT if is_horizontal_door else Vector3.BACK

	for x in range(offset - 1, offset + 1):
		var cell = door_position + (grid_direction * x)
		grid.set_cell_item(cell, -1)

	var door: Node3D = door_scene.instantiate()
	boundary.add_child(door)
	var door_name = "Door%s" % DoorDirection.keys()[door_rotation_index]
	door.name = door_name
	door.owner = scene

	var door_cell_offset: Vector3 = DOOR_GRID_OFFSETS[door_rotation_index]
	door.position = door_position + door_cell_offset
	door.rotate_y(door_rotation_index * PI / 2.0)

	return door
