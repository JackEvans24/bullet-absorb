class_name BossUI
extends Control

@export var label_path: NodePath
@export var bar_path: NodePath

@onready var title_label: Label = get_node(label_path)
@onready var health_bar: Bar = get_node(bar_path)

func initialise(data: BossSignalData):
    title_label.text = data.title

    health_bar.max_value = data.max_health
    health_bar.update_value(data.max_health)
