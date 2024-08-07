class_name PauseOverlay
extends Control

signal restart_requested

@onready var restart_button: Button = $RestartButton

func _ready():
	restart_button.pressed.connect(_on_restart_pressed)

func set_active():
	restart_button.grab_focus()

func _on_restart_pressed():
	restart_requested.emit()
