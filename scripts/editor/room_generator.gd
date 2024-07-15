@tool

class_name RoomGenerator
extends Node

const WALL_ITEM := 0
const FLOOR_ITEM := 1

@export var generate: bool = false: set = start_generation

@export_group("Size")
@export var depth := 10
@export var width := 10

func start_generation(_value: bool):
	if not Engine.is_editor_hint():
		return

	var grid: GridMap = $Room/Grid
	grid.clear()

	# Calculate wall positions
	# Set gridmap cells
	var pos := Vector3(0, 0, 0)
	for z in range( - depth / 2.0, depth / 2.0):
		for x in range( - width / 2.0, width / 2.0):
			pos.x = x
			pos.z = z
			if x == - width / 2.0 or x == width / 2.0 - 1:
				grid.set_cell_item(pos, WALL_ITEM)
			elif z == - depth / 2.0 or z == depth / 2.0 - 1:
				grid.set_cell_item(pos, WALL_ITEM)
			else:
				grid.set_cell_item(pos, FLOOR_ITEM)
