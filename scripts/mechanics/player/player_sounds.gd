class_name PlayerSounds
extends Node3D

@onready var dash_sfx: FmodEventEmitter3D = $DashSFX
@onready var hit_sfx: FmodEventEmitter3D = $HitSFX

func play(sfx: String):
	match sfx.to_lower():
		"dash":
			dash_sfx.play()
		"hit":
			hit_sfx.play()