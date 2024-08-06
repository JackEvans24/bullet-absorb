class_name PlayerSounds
extends Node3D

var sounds: Dictionary

func _ready():
	for child in get_children():
		if child is FmodEventEmitter3D:
			if sounds.has(child.name):
				printerr("Found duplicate sound: ", child.name)
				continue
			sounds[child.name] = child

func play(sfx: String):
	if not sounds.has(sfx):
		printerr("Trying to play sound that doesn't exist: ", sfx)
		return

	sounds[sfx].play()

func stop(sfx: String):
	if not sounds.has(sfx):
		printerr("Trying to stop sound that doesn't exist: ", sfx)
		return

	sounds[sfx].stop()