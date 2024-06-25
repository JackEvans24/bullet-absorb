class_name Power
extends Node3D

@onready var attraction_area = $PlayerAttractionArea
@onready var follow_body: FollowBody3D = $FollowBody

func _ready():
	attraction_area.body_entered.connect(_on_body_entered)

func _physics_process(_delta):
	if follow_body.target != null:
		translate(follow_body.movement)

func _on_body_entered(body: Node3D):
	follow_body.target = body