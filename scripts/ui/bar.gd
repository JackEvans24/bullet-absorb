class_name Bar
extends Control

@export var is_vertical := true

@export_group("Update animation")
@export var bar_speed = 1.0
@export var bar_colour: Color = Color.RED
@export var color_decay := 1.0
@export var flash_colour: Color = Color.WHITE

@export_group("Empty animation")
@export var background_flash_colour := Color.WHITE_SMOKE
@export var background_grow := 1.1
@export var background_decay := 1.5

@onready var foreground: ColorRect = $Foreground
@onready var background: ColorRect = $Background

@onready var background_colour: Color = background.color

var max_value := 1.0
var current_value := 0.0
var new_value := 0.0

var foreground_color_lerp := 0.0
var background_lerp := 0.0

func _ready():
	foreground.color = bar_colour
	current_value = foreground.size.y / size.y

func update_value(value: float):
	new_value = value
	foreground_color_lerp = 1.0

func trigger_flash_animation():
	background_lerp = 1.0

func _process(delta):
	update_bar_height(delta)
	update_foreground_color(delta)
	update_background_color(delta)

func update_bar_height(delta):
	if current_value == new_value:
		return

	var direction = sign(new_value - current_value)

	current_value = clamp(
		current_value + bar_speed * direction * delta,
		current_value if direction > 0 else new_value,
		new_value if direction > 0 else current_value
	)

	if is_vertical:
		foreground.size.x = size.x
		foreground.size.y = clampf(size.y * (current_value / max_value), 0.0, size.y)
	else:
		foreground.size.x = clampf(size.x * (current_value / max_value), 0.0, size.x)
		foreground.size.y = size.y

func update_foreground_color(delta):
	if foreground_color_lerp == 0.0:
		return
	foreground_color_lerp = max(0, foreground_color_lerp - color_decay * delta)
	foreground.color = lerp(bar_colour, flash_colour, foreground_color_lerp)

func update_background_color(delta):
	if background_lerp == 0.0:
		return
	background_lerp = max(0, background_lerp - background_decay * delta)
	background.color = lerp(background_colour, background_flash_colour, background_lerp)
	scale = Vector2.ONE * lerp(1.0, background_grow, background_lerp)
