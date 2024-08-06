class_name SoundEmitter
extends FmodEventEmitter3D

const EVENT_PARAM = "event_parameter/%s/value"

func update_parameter(param_name: String, value: float):
    var param_path = EVENT_PARAM % param_name
    set(param_path, value)