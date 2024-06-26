class_name RoomBoundary
extends Node3D

enum Walls {FORWARD = 1, BACK = 2, LEFT = 4, RIGHT = 8}

@onready var front_door: Door = $Front/Door
@onready var back_door: Door = $Back/Door
@onready var left_door: Door = $Left/Door
@onready var right_door: Door = $Right/Door

func set_doors(doors: int):
	front_door.set_closed(doors&Walls.FORWARD == 0)
	back_door.set_closed(doors&Walls.BACK == 0)
	left_door.set_closed(doors&Walls.LEFT == 0)
	right_door.set_closed(doors&Walls.RIGHT == 0)

func close_all_doors():
	front_door.set_closed(true)
	back_door.set_closed(true)
	left_door.set_closed(true)
	right_door.set_closed(true)