class_name VariableTimer
extends Timer

signal named_timeout(name: String)

var time_bounds: Array[VariableTimerConfig] = []

var config_index := 0
var iteration_index := 0

func _ready():
    var children = get_children()
    for child in children:
        time_bounds.push_back(child as VariableTimerConfig)

    timeout.connect(_on_timeout)
    restart()

func _on_timeout():
    iteration_index += 1

    if iteration_index < time_bounds[config_index].iterations:
        restart()
        return

    config_index += 1
    if config_index >= time_bounds.size():
        config_index = 0

    iteration_index = 0

    restart()

func restart():
    named_timeout.emit(time_bounds[config_index].name)
    wait_time = time_bounds[config_index].get_duration()
    start()
