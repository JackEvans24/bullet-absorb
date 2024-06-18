class_name CameraController
extends Node

@onready var follow_player: SmoothFollowTarget = $FollowPlayer

var target: Node3D:
	set(value): follow_player.target = value