class_name HitStop
extends Node

@export var freeze_duration: float = 0.05

var is_paused: bool = false

func freeze():
    if is_paused:
        return
    is_paused = true

    var tree = get_tree()
    tree.paused = true

    await tree.create_timer(freeze_duration, true, false, true).timeout

    tree.paused = false
    is_paused = false