@tool

class_name RoomGenerator
extends Node3D

const WALL_ITEM := 0
const FLOOR_ITEM := 1
const DOOR_SUPPORT_ITEM := 2

enum DoorDirection {NORTH = 0, EAST = 1, SOUTH = 2, WEST = 3}

const ROT_SOUTH := 0
const ROT_NORTH := 10
const ROT_EAST := 22
const ROT_WEST := 16

const HORIZONTAL_DOOR_OFFSET := Vector3(0, 0, 0.5)
const VERTICAL_DOOR_OFFSET := Vector3(0.5, 0, 0)

var doorway_rotations: Array[int] = [ROT_SOUTH, ROT_EAST, ROT_NORTH, ROT_WEST]

@export var generate: bool = false: set = start_generation

@export_group("Size")
@export var depth := 10
@export var width := 10

@export_group("Detection")
@export var detection_offset := 2.0
@export var detection_height := 2.0

@export_group("Doors")
@export var door_scene: PackedScene
@export_flags("NORTH", "SOUTH", "EAST", "WEST") var doors := 0

var grid: GridMap
var boundary: RoomBoundary

func start_generation(_value: bool):
	if not Engine.is_editor_hint():
		return

	# Set references
	grid = $Room/Grid
	boundary = $Room/Boundary

	# Clear existing grid
	for child in grid.get_children():
		print(child.name)
		grid.remove_child(child)
		child.queue_free()
	grid.clear()

	# Build walls
	var pos := Vector3(0, 0, 0)
	for z in range( - depth, depth):
		for x in range( - width, width):
			pos.x = x
			pos.z = z
			if x == - width:
				grid.set_cell_item(pos, WALL_ITEM, ROT_EAST)
			elif x == width - 1:
				grid.set_cell_item(pos, WALL_ITEM, ROT_WEST)
			elif z == - depth:
				grid.set_cell_item(pos, WALL_ITEM, ROT_NORTH)
			elif z == depth - 1:
				grid.set_cell_item(pos, WALL_ITEM, ROT_SOUTH)
			else:
				grid.set_cell_item(pos, FLOOR_ITEM)

	# Set doors
	if (doors&1 != 0):
		boundary.north_door = add_door(Vector3(0, 0, -depth), DoorDirection.NORTH)
	if (doors&2 != 0):
		boundary.south_door = add_door(Vector3(0, 0, depth - 1), DoorDirection.SOUTH)
	if (doors&4 != 0):
		boundary.east_door = add_door(Vector3(width - 1, 0, 0), DoorDirection.EAST)
	if (doors&8 != 0):
		boundary.west_door = add_door(Vector3( - width, 0, 0), DoorDirection.WEST)

	# Set player detection space
	var detection_shape: CollisionShape3D = $Room/PlayerDetection/Shape
	var box: BoxShape3D = detection_shape.shape
	box.size = Vector3((width * 2) - detection_offset, detection_height, (depth * 2) - detection_offset)

func add_door(door_position: Vector3, door_rotation_index: DoorDirection) -> Node3D:
	var is_horizontal_door = door_rotation_index % 2 == 0
	var grid_direction := Vector3.RIGHT if is_horizontal_door else Vector3.BACK

	for x in range( - 3, 3):
		var cell = door_position + (grid_direction * x)
		if x == (-3):
			grid.set_cell_item(cell, DOOR_SUPPORT_ITEM, ROT_NORTH if is_horizontal_door else ROT_WEST)
		elif x == 2:
			grid.set_cell_item(cell, DOOR_SUPPORT_ITEM, ROT_SOUTH if is_horizontal_door else ROT_EAST)
		else:
			grid.set_cell_item(cell, FLOOR_ITEM)

	var door: Node3D = door_scene.instantiate()
	grid.add_child(door)
	var door_name = "Door%s" % str(door_rotation_index)
	door.name = door_name

	var door_offset := HORIZONTAL_DOOR_OFFSET if is_horizontal_door else VERTICAL_DOOR_OFFSET
	door.position = door_position + door_offset
	door.rotate_y(door_rotation_index * PI / 2.0)

	return door