class_name PowerGenerator
extends Node3D

@export var cooldown: float = 0.3
@export var power_check_time: float = 0.1

@onready var power_check_area: Area3D = $PowerCheckArea
@onready var spawn_point: Node3D = $SpawnPoint
@onready var particles: GPUParticles3D = $SpawnParticles
@onready var drop_power: DropPower = $DropPower

var can_spawn := true

func _process(_delta):
    if power_check_area.has_overlapping_areas():
        return

    spawn_power()

func spawn_power():
    if not can_spawn:
        return
    can_spawn = false

    particles.restart()

    await get_tree().create_timer(cooldown).timeout

    drop_power.drop_all_power()

    await get_tree().create_timer(power_check_time).timeout

    can_spawn = true