class_name Pause
extends Node

var is_game_over := false

@onready var pause_overlay: PauseOverlay = $PauseOverlay

func _ready():
	pause_overlay.restart_requested.connect(restart_game)
	pause_overlay.quit_requested.connect(quit_game)

func _input(event: InputEvent):
	if event.is_action_pressed("pause"):
		handle_escape()

func handle_escape():
	if is_game_over:
		restart_game()
		return

	var tree = get_tree()
	tree.paused = !tree.paused

	pause_overlay.visible = tree.paused
	if tree.paused:
		pause_overlay.set_active()

func restart_game():
	var tree = get_tree()
	tree.call_group("bullet", "queue_free")
	tree.reload_current_scene()
	tree.paused = false

func quit_game():
	get_tree().quit()
