class_name AbsorbWindup
extends Node3D

@export var start_delay := 0.5
@export var max_absorb_size := 1.0

@onready var mesh: MeshInstance3D = $Mesh

var stats: PlayerStats

var is_windup_active := false
var current_windup_time := 0.0

var should_absorb: bool:
    get: return is_windup_active and current_windup_time > start_delay
var absorb_scale: float:
    get: return get_absorb_size()

func start_windup():
    current_windup_time = 0.0
    is_windup_active = true

func end_windup():
    is_windup_active = false
    current_windup_time = 0.0
    mesh.visible = false

func _process(delta):
    if not is_windup_active:
        return

    current_windup_time += delta

    if current_windup_time < start_delay:
        return
    if current_windup_time > start_delay + stats.absorb_windup:
        return

    mesh.scale = Vector3.ONE * get_absorb_size()
    mesh.visible = true

func get_absorb_size() -> float:
    if not should_absorb:
        return 0.0
    if current_windup_time > start_delay + stats.absorb_windup:
        return max_absorb_size
    return lerp(0.0, stats.absorb_area_scale, (current_windup_time - start_delay) / stats.absorb_windup)