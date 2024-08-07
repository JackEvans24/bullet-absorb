class_name Pause
extends Node

var is_game_over := false

@export var hud: Hud

func _input(event: InputEvent):
	if event.is_action_pressed("restart"):
		handle_escape()

func handle_escape():
	if is_game_over:
		restart_game()
		return

	var tree = get_tree()
	tree.paused = !tree.paused
	hud.set_pause_overlay(tree.paused)

func restart_game():
	get_tree().call_group("bullet", "queue_free")
	get_tree().reload_current_scene()
