class_name PlayerStats extends Resource

@export var max_health := 5
@export var max_power := 10.0
@export var power_conversion := 1.0
@export var fire_power_consumption_modifier := 1.0
@export var fire_cooldown_modifier := 1.0
@export var absorb_windup_modifier := 1.0
@export var absorb_area_scale := 1.0
@export var dash_power_consumption_modifier := 0.5

var fire_power_consumption: float:
    get: return 1.0 / fire_power_consumption_modifier

var dash_power_consumption: float:
    get: return 1.0 / dash_power_consumption_modifier

var absorb_windup: float:
    get: return 1.0 / absorb_windup_modifier

func get_fire_cooldown(cooldown: float) -> float:
    return cooldown / fire_cooldown_modifier