class_name MoveState
extends State

var movement: Vector3 = Vector3.ZERO
@export var can_aim: bool = true
@export var can_fire: bool = true
@export var can_absorb: bool = true
@export var can_take_damage: bool = true
@export var body_material: Material
@export var animation_trigger: String