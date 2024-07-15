@tool

class_name RoomGenerator
extends Node

const WALL_ITEM := 0
const FLOOR_ITEM := 1

@export var generate: bool = false: set = start_generation

@export_group("Size")
@export var depth := 10
@export var width := 10

@export_group("Detection")
@export var detection_offset := 2.0
@export var detection_height := 2.0

func start_generation(_value: bool):
	if not Engine.is_editor_hint():
		return

	var grid: GridMap = $Room/Grid
	grid.clear()

	# Calculate wall positions
	# Set gridmap cells
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

	var detection_shape: CollisionShape3D = $Room/PlayerDetection/Shape
	var box: BoxShape3D = detection_shape.shape
	box.size = Vector3(width - detection_offset, detection_height, depth - detection_offset)