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

	set_pause_state(!get_tree().paused)

func set_pause_state(paused: bool, quiet: bool = false):
	var tree = get_tree()
	tree.paused = paused

	pause_overlay.visible = paused
	Sounds.set_sounds_paused(paused)

	if not quiet:
		var sfx_name = "Pause" if paused else "Unpause"
		sfx.play(sfx_name)

	if paused:
		pause_overlay.set_active()
		pause_overlay.initialise(Sounds.sfx_volume)

func restart_game():
	var tree = get_tree()
	await tree.create_timer(0.2).timeout

	set_pause_state(false, true)

	tree.call_group("bullet", "queue_free")
	tree.call_group("power", "queue_free")
	tree.call_group("power_orb", "queue_free")

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
