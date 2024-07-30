class_name BossData
extends Resource

@export var title: String = "New Boss"
@export var max_health: float = 20.0
@export var power_count: int = 20
@export var boss_scene: PackedScene

func to_signal_data() -> BossSignalData:
    var data = BossSignalData.new()
    data.title = title
    data.max_health = max_health
    return data