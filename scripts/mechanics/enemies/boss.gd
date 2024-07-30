class_name Boss
extends Enemy

signal health_changed(current_health: float)

@export var title := "Boss"

func _ready():
    super()
    health.damage_taken.connect(_on_damage_taken)

func _on_damage_taken(_damage_taken: float, _taken_from: Node3D):
    health_changed.emit(health.current_health)