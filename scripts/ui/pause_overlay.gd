class_name PauseOverlay
extends Control

signal sfx_volume_changed(sfx_volume: float)
signal restart_requested
signal quit_requested

@onready var sfx_slider: DebouncedSlider = $SFX/Slider
@onready var restart_button: Button = $RestartButton
@onready var quit_button: Button = $QuitButton

func _ready():
	sfx_slider.debounced_change.connect(_on_sfx_volume_changed)
	restart_button.pressed.connect(_on_restart_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func initialise(sfx_volume: float):
	sfx_slider.value = sfx_volume

func set_active():
	restart_button.grab_focus()

func _on_sfx_volume_changed(value: float):
	sfx_volume_changed.emit(value)

func _on_restart_pressed():
	restart_requested.emit()

func _on_quit_pressed():
	quit_requested.emit()