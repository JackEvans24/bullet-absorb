class_name MouseAimDirection
extends AimDirection

@export var ground_offset = 1

@onready var viewport: Viewport = get_viewport()
@onready var camera: Camera3D = viewport.get_camera_3d()

var player: Node3D

func get_aim_direction() -> Vector3:
    var mouse_pos = viewport.get_mouse_position()
    var ray_origin = camera.project_ray_origin(mouse_pos)
    var direction = camera.project_ray_normal(mouse_pos).normalized()

    var angle = direction.angle_to(Vector3.DOWN)
    var forward = (ray_origin.y - ground_offset) * tan(angle)
    var aim_position = Vector3(ray_origin.x, ground_offset, ray_origin.z - forward)

    return aim_position - player.global_position