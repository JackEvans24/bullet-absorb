class_name ScreenShake
extends Node

@export_range(1.0, 10.0) var punch: float = 2.0
@export var tremolo = 5
@export var decay = 1.5
@export var trauma_amount = Vector3(1, 1, 0)

var cameras: Array[Node3D] = []

@onready var noise = FastNoiseLite.new()

var impulse: float = 0.0
var noise_y: int = 0

var offset = Vector3.ZERO

func register(camera: Node3D):
	cameras.push_back(camera)

func add_trauma():
	impulse = 1.0
	noise_y = 0
	noise.seed = randi_range(0, 99999)

func _process(delta):
	if impulse <= 0.0:
		return

	impulse = max(impulse - decay * delta, 0)
	shake()

func shake():
	noise_y += tremolo

	offset.x = get_offset(noise.seed, trauma_amount.x)
	offset.y = get_offset(noise.seed * 2, trauma_amount.y)

	for camera in cameras:
		camera.position = offset

func get_offset(noise_seed: float, max_trauma: float) -> float:
	var noise_output = noise.get_noise_2d(noise_seed, noise_y)
	var impulse_amount = pow(impulse, punch)
	return impulse_amount * noise_output * max_trauma