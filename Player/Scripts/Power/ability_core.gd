@abstract
class_name AbilityCore
extends Node2D

@export var power_level: int = 1

@onready var player: Player = $"../.."

@abstract func process(delta:float, powering: bool) -> void
@abstract func boot()->void
@abstract func shutdown()->void
