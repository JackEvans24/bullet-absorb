class_name BossUI
extends Control

@export var label_path: NodePath
@export var bar_path: NodePath

@onready var title_label: Label = get_node(label_path)
@onready var health_bar: Bar = get_node(bar_path)

func initialise(title: String, max_health: float):
    title_label.text = title

    health_bar.max_value = max_health
    health_bar.update_value(max_health)

func update_health(health: float):
    health_bar.update_value(health)
