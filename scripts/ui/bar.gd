class_name Bar
extends Control

@export var bar_speed = 1.0
@export var bar_colour: Color = Color.RED
@export var color_decay := 1.0
@export var flash_colour: Color = Color.WHITE

@onready var foreground: ColorRect = $Foreground

var max_value := 1.0
var current_value := 0.0
var new_value := 0.0

var color_lerp := 0.0

func _ready():
	foreground.color = bar_colour
	current_value = foreground.size.y / size.y

func update_value(value: float):
	new_value = value
	color_lerp = 1.0

func _process(delta):
	update_bar_height(delta)
	update_color(delta)

func update_bar_height(delta):
	if current_value == new_value:
		return

	var direction = sign(new_value - current_value)

	print([current_value, new_value, direction])

	current_value = clamp(
		current_value + bar_speed * direction * delta,
		current_value if direction > 0 else new_value,
		new_value if direction > 0 else current_value
	)
	foreground.size.y = clampf(size.y * (current_value / max_value), 0.0, size.y)

func update_color(delta):
	if color_lerp == 0.0:
		return
	color_lerp = max(0, color_lerp - color_decay * delta)
	foreground.color = lerp(bar_colour, flash_colour, color_lerp)
