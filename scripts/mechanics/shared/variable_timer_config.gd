class_name VariableTimerConfig
extends Node

@export var duration: float = 1.0
@export var duration_randomness: float = 0.2
@export var iterations: int = 1

func get_duration() -> float:
    if duration_randomness > 0.0:
        return randf_range(duration - duration_randomness, duration + duration_randomness)
    return duration