class_name PauseService
extends Node

var is_game_over := false

@onready var pause_overlay: PauseOverlay = $PauseOverlay
@onready var sfx: SoundBank = $SoundBank

func _ready():
	pause_overlay.initialise(Sounds.sfx_volume)

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
	Sounds.set_sounds_paused(tree.paused)

	var sfx_name = "Pause" if tree.paused else "Unpause"
	sfx.play(sfx_name)

	if tree.paused:
		pause_overlay.set_active()
		pause_overlay.initialise(Sounds.sfx_volume)

func restart_game():
	Sounds.set_sounds_paused(false)

	var tree = get_tree()
	tree.call_group("bullet", "queue_free")
	tree.reload_current_scene()

func _on_sfx_volume_changed(sfx_volume: float):
	if is_equal_approx(Sounds.sfx_volume, sfx_volume):
		return

	Sounds.set_sfx_volume(sfx_volume)
	sfx.play("VolumeUpdate")

	SaveSettings.settings_data.sfx_volume = sfx_volume
	SaveSettings.save()

func _on_restart_requested():
	get_tree().paused = false
	restart_game()

func on_quit_requested():
	get_tree().quit()
