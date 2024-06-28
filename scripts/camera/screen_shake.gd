class_name ScreenShake
extends Node

@export var punch: float = 2.0
@export var tremolo = 5
@export var decay = 1.5

@export var impulse_max = Vector3(2.5, 2.0, 0)
@export var roll_max = 0.1

var cameras: Array[Node3D] = []

@onready var noise = FastNoiseLite.new()

var impulse: float = 0.0
var noise_y: int = 0

var offset = Vector3.ZERO
var roll: float = 0.0

func register(camera: Node3D):
	cameras.push_back(camera)

func add_impulse(impulse_amount: float):
	impulse = max(impulse, impulse_amount)
	noise_y = 0
	noise.seed = randi_range(0, 99999)

func _process(delta):
	if impulse <= 0.0:
		return
	impulse = max(impulse - decay * delta, 0)
	shake()

func shake():
	noise_y += tremolo

	offset.x = get_offset(noise.seed, impulse_max.x)
	offset.y = get_offset(noise.seed * 2, impulse_max.y)
	roll = get_offset(noise.seed * 3, roll_max)

	for camera in cameras:
		camera.position = offset
		camera.rotation.z = roll

func get_offset(noise_seed: float, max_trauma: float) -> float:
	var noise_output = noise.get_noise_2d(noise_seed, noise_y)
	var active_impulse = pow(impulse, punch)
	return active_impulse * noise_output * max_trauma