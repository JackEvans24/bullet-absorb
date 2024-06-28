class_name RoomController extends Node

signal room_activated
signal room_completed

var rooms: Array[Room]

func _ready():
    var children = get_children()
    print(children)
    for child in children:
        var room = child as Room
        room.room_activated.connect(_on_room_activated)
        room.room_completed.connect(_on_room_completed)
        rooms.push_back(child as Room)

func _on_room_activated():
    room_activated.emit()

func _on_room_completed():
    room_completed.emit()
