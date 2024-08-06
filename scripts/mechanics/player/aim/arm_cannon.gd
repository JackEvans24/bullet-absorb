class_name ArmCannon extends Node3D

@export var fire_point: Node3D
@export var aim_reference_point: Node3D
@export var fire_fail_particles_scene: PackedScene

@onready var fire_sfx: FmodEventEmitter3D = $FireSFX
@onready var fire_fail_sfx: FmodEventEmitter3D = $FireFailSFX

func fire(bullet: Bullet):
    bullet.global_position = fire_point.global_position
    bullet.initialise(self.global_basis)
    fire_sfx.play()

func trigger_fire_fail():
    fire_fail_sfx.play()
    var particles = fire_fail_particles_scene.instantiate()
    add_child(particles)
    particles.global_position = fire_point.global_position

func aim_towards(reticule_position: Vector3):
    reticule_position.y = aim_reference_point.global_position.y
    var reticule_direction = reticule_position - aim_reference_point.global_position
    look_at(self.global_position + reticule_direction.normalized())