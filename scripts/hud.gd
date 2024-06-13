class_name Hud
extends Node

@onready var health_label: Label = $HealthLabel
@onready var power_label: Label = $PowerLabel

func _on_health_changed(current_health: float):
	health_label.text = "Health: %.0f" % current_health

func _on_absorb_count_changed(count: int):
	power_label.text = "Power: %s" % count