class_name PowerBall
extends Node3D

@export var max_speed = 5.0
@export var acceleration = 0.1

var player: Node3D = null
var current_speed = 0.0

@onready var attraction_area = $PlayerAttractionArea

func _ready():
	attraction_area.body_entered.connect(_on_body_entered)

func _physics_process(delta):
	if player == null:
		return

	var offset = player.position - position

	current_speed = min(current_speed + (acceleration * delta), max_speed)
	current_speed = min(current_speed, offset.length())

	translate(offset.normalized() * current_speed)

func _on_body_entered(body: Node3D):
	if body == null or player != null:
		return
	player = body