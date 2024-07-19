class_name ScreenShake
extends Node

@export var lookup: ScreenShakeLookup

var cameras: Array[Node3D] = []

@onready var noise = FastNoiseLite.new()

var profile: ScreenShakeProfile
var current_profile_id: ScreenShakeMapping.ScreenShakeId

var impulse: float = 0.0
var noise_y: int = 0

var offset = Vector3.ZERO
var roll: float = 0.0

func register(camera: Node3D):
	cameras.push_back(camera)

func add_impulse(id: ScreenShakeMapping.ScreenShakeId):
	var new_profile = lookup.get_profile(id)
	if new_profile == null:
		printerr("No screen shake mapping profile found for ID: %s" % ScreenShakeMapping.ScreenShakeId.keys()[id])
		return

	if has_lower_priority(new_profile):
		return

	profile = new_profile
	current_profile_id = id

	impulse = 1.0
	noise_y = 0
	noise.seed = randi_range(0, 99999)

func has_lower_priority(new_profile: ScreenShakeProfile) -> bool:
	if impulse <= 0.0:
		return false
	if profile == null:
		return false
	return profile.priority > new_profile.priority

func cancel_impulse(id: ScreenShakeMapping.ScreenShakeId):
	if current_profile_id != id:
		return
	impulse = 0.0

func _process(delta):
	if impulse <= 0.0:
		return
	impulse = max(impulse - profile.decay * delta, 0)
	shake()

func shake():
	noise_y += profile.tremolo

	offset.x = get_offset(noise.seed, profile.impulse_max.x)
	offset.y = get_offset(noise.seed * 2, profile.impulse_max.y)
	roll = get_offset(noise.seed * 3, profile.roll_max)

	for camera in cameras:
		camera.position = offset
		camera.rotation.z = roll

func get_offset(noise_seed: float, max_trauma: float) -> float:
	var noise_output = noise.get_noise_2d(noise_seed, noise_y)
	var active_impulse = pow(impulse, profile.punch)
	return active_impulse * noise_output * max_trauma
