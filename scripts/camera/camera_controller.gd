class_name CameraController
extends Node

@onready var follow_player: SmoothFollowTarget = $FollowPlayer
@onready var camera: Camera3D = $FollowPlayer/PlayerCamera/Camera
@onready var screen_shake: ScreenShake = $ScreenShake

var target: Node3D:
	set(value): follow_player.target = value

func _ready():
	screen_shake.register(camera)
	pass

func add_impulse(id: ScreenShakeMapping.ScreenShakeId):
	screen_shake.add_impulse(id)
