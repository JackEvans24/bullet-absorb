class_name Hud
extends Node

@export var death_overlay_timer := 1.5

@onready var health_bar: Bar = $HealthBar
@onready var power_bar: Bar = $PowerBar
@onready var death_overlay: ColorRect = $DeathOverlay
@onready var boss_ui: BossUI = $BossUI

var saved_dash_state := true

func update(player: Player):
	update_bar(health_bar, player.stats.max_health, player.current_health)
	update_bar(power_bar, player.stats.max_power, player.power_count)

func update_bar(bar: Bar, max_value: float, current_value: float):
	bar.max_value = max_value
	bar.update_value(current_value)

func initialise_boss_ui(boss: Boss):
	boss_ui.initialise(boss.title, boss.max_health)
	boss_ui.visible = true

	boss.health_changed.connect(_on_boss_health_changed)
	boss.died.connect(_on_boss_died)

func _on_boss_health_changed(current_health: float):
	boss_ui.update_health(current_health)

func _on_boss_died():
	boss_ui.visible = false

func _on_health_changed(current_health: float):
	health_bar.update_value(current_health)
	health_bar.trigger_flash_animation()

func _on_power_count_changed(count: float):
	power_bar.update_value(count)

func _on_power_check_failed():
	power_bar.trigger_flash_animation()

func _on_player_died():
	await get_tree().create_timer(death_overlay_timer).timeout
	death_overlay.visible = true