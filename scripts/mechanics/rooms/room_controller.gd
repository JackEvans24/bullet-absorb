class_name RoomController extends Node

signal doors_changed

var rooms: Array[Room]

func _ready():
    var children = get_children()
    for child in children:
        var room = child as Room
        room.room_doors_changed.connect(_on_room_activated)
        rooms.push_back(child as Room)

func _on_room_activated():
    doors_changed.emit()
