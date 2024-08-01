class_name AbsorbWindup
extends Node3D

@export var start_delay := 0.5
@export var max_absorb_size := 1.0
@export var interpolation_curve: Curve

@onready var mesh: MeshInstance3D = $Mesh
@onready var particles: GPUParticles3D = $Particles

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
    enable_particles(true)

func end_windup():
    is_windup_active = false
    current_windup_time = 0.0
    mesh.visible = false
    enable_particles(false)

func enable_particles(enabled: bool):
    particles.emitting = enabled
    particles.visible = enabled

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
        return 0.01
    if current_windup_time > start_delay + stats.absorb_windup:
        return max_absorb_size

    var t = (current_windup_time - start_delay) / stats.absorb_windup
    var projected_t = interpolation_curve.sample(t)
    return lerp(0.0, stats.absorb_area_scale, projected_t)