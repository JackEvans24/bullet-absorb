class_name AbsorbWindup
extends Node3D

@export var start_delay := 0.5
@export var interpolation_curve: Curve

@export_group("Emission")
@export var max_emission := 3.0
@export var absorb_material: BaseMaterial3D

@onready var mesh: MeshInstance3D = $Mesh
@onready var in_particles: GPUParticles3D = $InwardParticles
@onready var out_particles: GPUParticles3D = $OutwardParticles

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
    enable_in_particles(true)

func end_windup():
    is_windup_active = false
    current_windup_time = 0.0
    mesh.visible = false
    enable_in_particles(false)
    enable_out_particles(false)

func enable_in_particles(enabled: bool):
    in_particles.emitting = enabled
    in_particles.visible = enabled

func enable_out_particles(enabled: bool):
    out_particles.emitting = enabled
    out_particles.process_material.emission_sphere_radius = 0.01

func _process(delta):
    if not is_windup_active:
        return

    current_windup_time += delta

    if current_windup_time < start_delay:
        return
    if current_windup_time > start_delay + stats.absorb_windup:
        return

    var absorb_size = get_absorb_size()
    mesh.scale = Vector3.ONE * absorb_size
    out_particles.process_material.emission_sphere_radius = absorb_size
    absorb_material.emission_energy_multiplier = max_emission * get_t()

    if not mesh.visible:
        mesh.visible = true
        enable_out_particles(true)

func get_absorb_size() -> float:
    if not should_absorb:
        return 0.01
    if current_windup_time > start_delay + stats.absorb_windup:
        return stats.absorb_area_scale

    var projected_t = get_lerp_value()
    return lerp(0.0, stats.absorb_area_scale, projected_t)

func get_t() -> float:
    return (current_windup_time - start_delay) / stats.absorb_windup

func get_lerp_value() -> float:
    var t = get_t()
    return interpolation_curve.sample(t)
