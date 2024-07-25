class_name PowerOrb
extends Node3D

@export var power_count := 5

@onready var orb: AbsorbOrb = $Orb
@onready var drop_power: DropPower = $DropPower

func _ready():
	drop_power.power_drop_count = power_count
	orb.orb_absorbed.connect(_on_orb_absorbed)
	orb.orb_destroyed.connect(_on_orb_destroyed)

# TODO: HOOK UP SCREEN SHAKE?
func _on_orb_absorbed():
	call_deferred("drop_all_power")

func _on_orb_destroyed():
	call_deferred("handle_destruction")

func drop_all_power():
	drop_power.drop_all_power()

func handle_destruction():
	queue_free()