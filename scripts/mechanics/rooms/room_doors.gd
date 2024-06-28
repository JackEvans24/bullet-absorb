class_name RoomBoundary
extends Node3D

enum Walls {FORWARD = 1, BACK = 2, LEFT = 4, RIGHT = 8}

@onready var front_door: Door = $Front/Door
@onready var back_door: Door = $Back/Door
@onready var left_door: Door = $Left/Door
@onready var right_door: Door = $Right/Door

func doors_need_changing(doors: int) -> bool:
	if (doors&Walls.FORWARD != 0) == front_door.is_closed:
		return true
	if (doors&Walls.BACK != 0) == back_door.is_closed:
		return true
	if (doors&Walls.LEFT != 0) == left_door.is_closed:
		return true
	if (doors&Walls.RIGHT != 0) == right_door.is_closed:
		return true
	return false

func set_doors(doors: int):
	front_door.set_closed(doors&Walls.FORWARD == 0)
	back_door.set_closed(doors&Walls.BACK == 0)
	left_door.set_closed(doors&Walls.LEFT == 0)
	right_door.set_closed(doors&Walls.RIGHT == 0)
