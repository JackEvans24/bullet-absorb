class_name Hud
extends Node

@export var death_overlay_timer := 1.5

@onready var health_bar: Bar = $HealthBar
@onready var power_bar: Bar = $PowerBar
@onready var death_overlay: ColorRect = $DeathOverlay

func initialise_max_values(max_health: float, max_power: float):
	health_bar.max_value = max_health
	health_bar.update_value(max_health)
	power_bar.max_value = max_power
	power_bar.update_value(0.0)

func _on_health_changed(current_health: float):
	health_bar.update_value(current_health)

func _on_absorb_count_changed(count: int):
	power_bar.update_value(count)

func _on_player_died():
	await get_tree().create_timer(death_overlay_timer).timeout
	death_overlay.visible = true