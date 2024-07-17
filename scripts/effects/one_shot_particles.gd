extends GPUParticles3D

func _ready():
	finished.connect(_on_particles_finished)
	restart()

func _on_particles_finished():
	call_deferred("queue_free")
