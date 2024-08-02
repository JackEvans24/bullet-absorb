class_name ScreenShakeFrameData

var impulse := 1.0
var noise: FastNoiseLite
var noise_y := 0

func _init():
    noise = FastNoiseLite.new()
    noise.seed = randi_range(0, 99999)

func get_offset(profile: ScreenShakeProfile, seed_multiplier: float, max_trauma: float):
    var noise_output = noise.get_noise_2d(noise.seed * seed_multiplier, noise_y)
    var active_impulse = pow(impulse, profile.punch)
    return active_impulse * noise_output * max_trauma
