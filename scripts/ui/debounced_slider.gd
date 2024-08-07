class_name DebouncedSlider
extends Slider

signal debounced_change(value: float)

@export var debounce_time_ms := 200

var previous_change_time := 0
var awaiting_emit = false

func _ready():
    value_changed.connect(_on_value_changed)

func _process(_delta):
    if not awaiting_emit:
        return

    var current_time = Time.get_ticks_msec()
    if current_time < previous_change_time + debounce_time_ms:
        return

    debounced_change.emit(value)
    awaiting_emit = false

func _on_value_changed(_value: float):
    previous_change_time = Time.get_ticks_msec()
    awaiting_emit = true