class_name Hud
extends Node

@onready var power_label: Label = $PowerLabel

func _on_absorb_count_changed(count: int):
	power_label.text = "Power: %s" % count