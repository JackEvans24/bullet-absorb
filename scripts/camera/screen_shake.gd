class_name ScreenShake
extends Node

@export var lookup: ScreenShakeLookup

var cameras: Array[Node3D] = []

var active_profiles: Dictionary

var offset = Vector3.ZERO
var roll: float = 0.0

func register(camera: Node3D):
	cameras.push_back(camera)

func add_impulse(id: ScreenShakeMapping.ScreenShakeId):
	var profile = lookup.get_profile(id)
	if profile == null:
		printerr("No screen add_shake mapping active_profile found for ID: %s" % ScreenShakeMapping.ScreenShakeId.keys()[id])
		return

	var active_profile = active_profiles.get(id) as ScreenShakeFrameData
	if active_profile != null and active_profile.impulse > 1.0:
		return

	active_profiles[id] = ScreenShakeFrameData.new()

func cancel_impulse(id: ScreenShakeMapping.ScreenShakeId):
	active_profiles.erase(id)

func _process(delta):
	var active_profile_ids = active_profiles.keys()

	for profile_id in active_profile_ids:
		update_frame_data(profile_id, delta)

	for profile_id in active_profile_ids:
		add_shake(profile_id)

func update_frame_data(id: ScreenShakeMapping.ScreenShakeId, delta: float):
	var frame_data = active_profiles.get(id) as ScreenShakeFrameData
	if not frame_data:
		return
	var profile = lookup.get_profile(id)

	frame_data.impulse = clampf(frame_data.impulse - profile.decay * delta, 0.0, profile.max_intensity)
	frame_data.noise_y += profile.tremolo

	if is_equal_approx(frame_data.impulse, 0.0):
		active_profiles.erase(id)
		return

func add_shake(id: ScreenShakeMapping.ScreenShakeId):
	var frame_data = active_profiles.get(id) as ScreenShakeFrameData
	if not frame_data:
		return
	var profile = lookup.get_profile(id)

	offset.x = frame_data.get_offset(profile, 1.0, profile.impulse_max.x)
	offset.y = frame_data.get_offset(profile, 2.0, profile.impulse_max.y)
	roll = frame_data.get_offset(profile, 3.0, profile.roll_max)

	for camera in cameras:
		camera.position = offset
		camera.rotation.z = roll
