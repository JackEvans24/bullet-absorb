class_name ButtonWithSfx
extends Button

@onready var select_sfx: FmodEventEmitter3D = $SelectSFX

func _ready():
    focus_entered.connect(play_selected_sfx)
    mouse_entered.connect(play_selected_sfx)

func play_selected_sfx():
    select_sfx.play()