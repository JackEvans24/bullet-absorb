class_name Hud
extends Node

@export var death_overlay_timer := 1.5

@onready var health_bar: Bar = $HealthBar
@onready var power_bar: Bar = $PowerBar
@onready var stamina_bar: Bar = $StaminaBar
@onready var death_overlay: ColorRect = $DeathOverlay

func initialise_stats(stats: PlayerStats):
	update_bar(health_bar, stats.max_health, stats.max_health)
	update_bar(power_bar, stats.max_power, 0.0)
	update_bar(stamina_bar, 1.0, 1.0)

func update_bar(bar: Bar, max_value: float, current_value: float):
	bar.max_value = max_value
	bar.update_value(current_value)

func _on_health_changed(current_health: float):
	health_bar.update_value(current_health)

func _on_power_count_changed(count: float):
	power_bar.update_value(count)

func _on_can_dash_changed(can_dash: bool):
		stamina_bar.update_value(1.0 if can_dash else 0.0)

func _on_player_died():
	await get_tree().create_timer(death_overlay_timer).timeout
	death_overlay.visible = true