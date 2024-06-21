class_name Bar
extends Control

@export var bar_speed = 1.0
@export var bar_colour: Color = Color.RED

@onready var foreground: ColorRect = $Foreground

var max_value := 1.0
var current_value := 1.0
var new_value := 0.0

func _ready():
	foreground.color = bar_colour

func update_value(value: float):
	new_value = value

func _process(delta):

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
