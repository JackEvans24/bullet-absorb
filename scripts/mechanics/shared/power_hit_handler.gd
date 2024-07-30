class_name PowerHitHandler
extends Node

signal power_connected(power: Node3D)

func trigger(power: Node3D):
    power_connected.emit(power)