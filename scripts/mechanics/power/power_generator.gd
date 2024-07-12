class_name PowerGenerator
extends Node3D

@export var cooldown: float = 0.3
@export var power_count: int = 5
@export var power_check_timer: float = 0.3

@onready var power_check_area: Area3D = $PowerCheckArea
@onready var spawn_point: Node3D = $SpawnPoint
@onready var particles: GPUParticles3D = $SpawnParticles
@onready var drop_power: DropPower = $DropPower
@onready var animation: AnimationPlayer = $Animator

var can_spawn := false
var needs_cooldown := false

func _ready():
    drop_power.power_drop_count = power_count

func _on_start_animation_complete():
    can_spawn = true
    animation.play("idle")

func _process(_delta):
    if power_check_area.has_overlapping_areas():
        return

    spawn_power()

func spawn_power():
    if not can_spawn:
        return
    can_spawn = false

    if needs_cooldown:
        await get_tree().create_timer(cooldown).timeout

    particles.restart()

    await get_tree().create_timer(particles.lifetime).timeout

    drop_power.drop_all_power()

    await get_tree().create_timer(power_check_timer).timeout

    needs_cooldown = true
    can_spawn = true