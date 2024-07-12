class_name AbsorbHandler
extends Node

signal absorb_triggered

func trigger_absorb():
	absorb_triggered.emit()