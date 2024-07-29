class_name Hud
extends Node

@export var death_overlay_timer := 1.5

@onready var health_bar: Bar = $HealthBar
@onready var power_bar: Bar = $PowerBar
@onready var death_overlay: ColorRect = $DeathOverlay

var saved_dash_state := true

func update(player: Player):
	update_bar(health_bar, player.stats.max_health, player.current_health)
	update_bar(power_bar, player.stats.max_power, player.power_count)

func update_bar(bar: Bar, max_value: float, current_value: float):
	bar.max_value = max_value
	bar.update_value(current_value)

func _on_health_changed(current_health: float):
	health_bar.update_value(current_health)

func _on_power_count_changed(count: float):
	power_bar.update_value(count)

func _on_power_check_failed():
	power_bar.trigger_flash_animation()

func _on_player_died():
	await get_tree().create_timer(death_overlay_timer).timeout
	death_overlay.visible = true