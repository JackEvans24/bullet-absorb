class_name ArmCannon extends Node3D

@export var fire_point: Node3D
@export var aim_reference_point: Node3D
@export var fire_fail_particles_scene: PackedScene

func initialise_bullet(bullet: Bullet):
    bullet.global_position = fire_point.global_position
    bullet.initialise(self.global_basis)

func trigger_fire_fail():
    var particles = fire_fail_particles_scene.instantiate()
    add_child(particles)
    particles.global_position = fire_point.global_position

func aim_towards(reticule_position: Vector3):
    reticule_position.y = aim_reference_point.global_position.y
    var reticule_direction = reticule_position - aim_reference_point.global_position
    look_at(self.global_position + reticule_direction.normalized())