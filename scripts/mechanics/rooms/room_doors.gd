class_name RoomBoundary
extends Node3D

enum Walls {NORTH = 1, SOUTH = 2, EAST = 4, WEST = 8}

@onready var north_door: Door = $North/Door
@onready var south_door: Door = $South/Door
@onready var east_door: Door = $East/Door
@onready var west_door: Door = $West/Door

func doors_need_changing(doors: int) -> bool:
	if (doors&Walls.NORTH != 0) == north_door.is_closed:
		return true
	if (doors&Walls.SOUTH != 0) == south_door.is_closed:
		return true
	if (doors&Walls.WEST != 0) == west_door.is_closed:
		return true
	if (doors&Walls.EAST != 0) == east_door.is_closed:
		return true
	return false

func set_doors(doors: int):
	north_door.set_closed(doors&Walls.NORTH == 0)
	south_door.set_closed(doors&Walls.SOUTH == 0)
	west_door.set_closed(doors&Walls.WEST == 0)
	east_door.set_closed(doors&Walls.EAST == 0)
