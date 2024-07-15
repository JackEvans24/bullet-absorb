@tool

class_name RoomGenerator
extends Node3D

const WALL_ITEM := 0
const FLOOR_ITEM := 1
const DOOR_SUPPORT_ITEM := 2

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
			if x == - width or x == width - 1:
				grid.set_cell_item(pos, WALL_ITEM)
			elif z == - depth or z == depth - 1:
				grid.set_cell_item(pos, WALL_ITEM)
			else:
				grid.set_cell_item(pos, FLOOR_ITEM)

	# Set doors
	if (doors&1 != 0):
		boundary.north_door = add_door(Vector3(0, 0, -depth), Vector3.RIGHT, "NorthDoor")
	if (doors&2 != 0):
		boundary.south_door = add_door(Vector3(0, 0, depth - 1), Vector3.RIGHT, "SouthDoor")
	if (doors&4 != 0):
		boundary.east_door = add_door(Vector3(width - 1, 0, 0), Vector3.BACK, "EastDoor", PI / 2.0)
	if (doors&8 != 0):
		boundary.west_door = add_door(Vector3( - width, 0, 0), Vector3.BACK, "WestDoor", PI / 2.0)

	# Set player detection space
	var detection_shape: CollisionShape3D = $Room/PlayerDetection/Shape
	var box: BoxShape3D = detection_shape.shape
	box.size = Vector3((width * 2) - detection_offset, detection_height, (depth * 2) - detection_offset)

func add_door(door_position: Vector3, grid_direction: Vector3, door_name: String, door_rotation: float=0.0) -> Node3D:
	for x in range( - 3, 3):
		var cell = door_position + (grid_direction * x)
		print(cell)
		if x == - 3 or x == 2:
			grid.set_cell_item(cell, DOOR_SUPPORT_ITEM)
		else:
			grid.set_cell_item(cell, GridMap.INVALID_CELL_ITEM)

	var door: Node3D = door_scene.instantiate()
	grid.add_child(door)
	door.name = door_name
	door.position = door_position
	door.rotate_y(door_rotation)

	return door