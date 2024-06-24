class_name VariableTimer
extends Timer

var time_bounds: Array[VariableTimerConfig] = []

var config_index := 0
var iteration_index := 0

func _ready():
    var children = get_children()
    for child in children:
        time_bounds.push_back(child as VariableTimerConfig)

    wait_time = time_bounds[config_index].duration

    timeout.connect(_on_timeout)
    start()

func _on_timeout():
    iteration_index += 1

    if iteration_index < time_bounds[config_index].iterations:
        start()
        return

    config_index += 1
    if config_index >= time_bounds.size():
        config_index = 0

    iteration_index = 0
    wait_time = time_bounds[config_index].duration

    start()