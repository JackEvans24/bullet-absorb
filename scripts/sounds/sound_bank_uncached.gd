class_name SoundBankUncached
extends Node3D

func play(sfx: String):
	var sound = find_child(sfx)
	if not sound:
		printerr("Trying to play sound that doesn't exist: ", sfx)
		return

	sound.play()

func stop(sfx: String):
	var sound = find_child(sfx)
	if not sound:
		printerr("Trying to stop sound that doesn't exist: ", sfx)
		return

	sound.stop()