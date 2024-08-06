class_name PlayerSounds
extends Node3D

@onready var dash_sfx: FmodEventEmitter3D = $DashSFX

func play(sfx: String):
	match sfx.to_lower():
		"dash":
			dash_sfx.play()