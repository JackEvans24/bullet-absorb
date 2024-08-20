class_name RoomBoundary
extends Node3D

enum Walls {NORTH = 1, SOUTH = 2, EAST = 4, WEST = 8}

var doors: Array[Door]
var open: bool = false

func _ready():
	for child in get_children():
		if child is Door:
			doors.append(child)

func doors_need_changing(new_open: bool) -> bool:
	return new_open != open

func set_doors(new_open: bool):
	open = new_open
	for door in doors:
		door.set_closed(not new_open)
