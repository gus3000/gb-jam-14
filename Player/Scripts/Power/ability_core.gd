@abstract
class_name AbilityCore
extends Node2D

@export var power_level: int = 0:
	set(value):
		value = clamp(value, 0, max_power_level)
		power_level = value
@export var max_power_level: int = 6

@onready var player: Player = $"../.."

@abstract func process(delta:float, powering: bool) -> void
@abstract func boot() -> void
@abstract func shutdown() -> void
@abstract func get_power() -> PowerCore.Power
