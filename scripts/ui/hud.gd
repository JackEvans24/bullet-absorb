class_name Hud
extends Node

@export var death_overlay_timer := 1.5

@onready var health_label: Label = $HealthLabel
@onready var power_label: Label = $PowerLabel
@onready var death_overlay: ColorRect = $DeathOverlay

func _on_health_changed(current_health: float):
	health_label.text = "Health: %.0f" % current_health

func _on_absorb_count_changed(count: int):
	power_label.text = "Power: %s" % count

func _on_player_died():
	await get_tree().create_timer(death_overlay_timer).timeout
	death_overlay.visible = true