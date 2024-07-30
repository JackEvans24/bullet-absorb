class_name RewardPickup extends Node3D

signal reward_collected(reward_type: Reward.RewardType)

var reward: Reward

@export var fallback_texture: Texture2D

@onready var orb: AbsorbOrb = $Orb
@onready var orb_mesh: MeshInstance3D = $Orb/Mesh
@onready var drop_power: DropPower = $DropPower

func _ready():
	set_shader_texture()

	orb.orb_absorbed.connect(_on_orb_absorbed)
	orb.orb_destroyed.connect(_on_orb_destroyed)

func set_shader_texture():
	var shader_material: ShaderMaterial = orb_mesh.get_surface_override_material(0).next_pass
	if not shader_material:
		printerr("Shader not found in reward pickup")
		return

	var texture = fallback_texture if not reward.pickup_texture else reward.pickup_texture
	shader_material.set_shader_parameter("surface_texture", texture)

func _on_orb_absorbed():
	reward_collected.emit(reward.reward_type)
	drop_power.drop_all_power()

func _on_orb_destroyed():
	call_deferred("queue_free")
