class_name PreAbsorbHandler
extends Node

signal pre_absorb_triggered(active: bool)

func trigger_enter():
	pre_absorb_triggered.emit(true)

func trigger_exit():
	pre_absorb_triggered.emit(false)