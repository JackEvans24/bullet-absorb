class_name RoomBoundary
extends Node3D

enum Walls {NORTH = 1, SOUTH = 2, EAST = 4, WEST = 8}

@export var north_door_ref: NodePath
@export var south_door_ref: NodePath
@export var east_door_ref: NodePath
@export var west_door_ref: NodePath

@onready var north_door: Door = get_node(north_door_ref)
@onready var south_door: Door = get_node(south_door_ref)
@onready var east_door: Door = get_node(east_door_ref)
@onready var west_door: Door = get_node(west_door_ref)

func doors_need_changing(doors: int) -> bool:
	if north_door != null&&(doors&Walls.NORTH != 0) == north_door.is_closed:
		return true
	if south_door != null&&(doors&Walls.SOUTH != 0) == south_door.is_closed:
		return true
	if east_door != null&&(doors&Walls.EAST != 0) == east_door.is_closed:
		return true
	if west_door != null&&(doors&Walls.WEST != 0) == west_door.is_closed:
		return true
	return false

func set_doors(doors: int):
	if north_door != null:
		north_door.set_closed(doors&Walls.NORTH == 0)
	if south_door != null:
		south_door.set_closed(doors&Walls.SOUTH == 0)
	if west_door != null:
		west_door.set_closed(doors&Walls.WEST == 0)
	if east_door != null:
		east_door.set_closed(doors&Walls.EAST == 0)
