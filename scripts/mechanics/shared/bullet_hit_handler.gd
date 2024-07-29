class_name BulletHitHandler
extends Node

signal bullet_connected(bullet: Node3D)

func trigger(bullet: Node3D):
    bullet_connected.emit(bullet)