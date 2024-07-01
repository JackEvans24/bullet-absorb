class_name SpawnTube extends Node3D

@onready var animator: AnimationPlayer = $Animator

func play_animation():
    animator.play("start")