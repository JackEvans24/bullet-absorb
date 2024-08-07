class_name Pause
extends Node

const SFX_BUS_PATH = "bus:/SFX"

var is_game_over := false

@onready var pause_overlay: PauseOverlay = $PauseOverlay
@onready var sfx_bus: FmodBus = FmodServer.get_bus(SFX_BUS_PATH)

func _ready():
	pause_overlay.sfx_volume_changed.connect(_on_sfx_volume_changed)
	pause_overlay.restart_requested.connect(_on_restart_requested)
	pause_overlay.quit_requested.connect(on_quit_requested)

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
		pause_overlay.initialise(sfx_bus.volume)

func restart_game():
	var tree = get_tree()
	tree.call_group("bullet", "queue_free")
	tree.reload_current_scene()

func _on_sfx_volume_changed(sfx_volume: float):
	sfx_bus.volume = sfx_volume

func _on_restart_requested():
	get_tree().paused = false
	restart_game()

func on_quit_requested():
	get_tree().quit()
