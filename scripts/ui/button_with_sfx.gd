class_name ButtonWithSfx
extends Button

@onready var select_sfx: FmodEventEmitter3D = $SelectSFX
@onready var press_sfx: FmodEventEmitter3D = $PressSFX

func _ready():
    focus_entered.connect(play_selected_sfx)
    mouse_entered.connect(play_selected_sfx)
    pressed.connect(play_pressed_sfx)

func play_selected_sfx():
    select_sfx.play()

func play_pressed_sfx():
    press_sfx.play()