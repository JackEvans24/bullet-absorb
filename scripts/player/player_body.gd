class_name PlayerBody
extends Node3D

@export var default_material: Material
@export var recovery_material: Material

@onready var body: MeshInstance3D = $Body
@onready var nose: MeshInstance3D = $Nose
@onready var hurt_particles: GPUParticles3D = $HurtParticles

func _on_recovery_changed(is_recovering: bool):
	body.set_surface_override_material(0, recovery_material if is_recovering else default_material)

func _on_damage_taken(damage_taken: float, _taken_from: Node3D):
	if damage_taken <= 0:
		return
	hurt_particles.restart()

func _on_player_died():
	body.visible = false
	nose.visible = false