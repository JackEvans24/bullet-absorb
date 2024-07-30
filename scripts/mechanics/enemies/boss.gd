class_name Boss
extends Enemy

signal health_changed(current_health: float)

@export var title := "Boss"

func _on_damage_taken(damage_taken: float, taken_from: Node3D):
    health_changed.emit(health.current_health)
    super(damage_taken, taken_from)