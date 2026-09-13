class_name PowerCore
extends Node2D

enum Power {MINING, LADDER}


@export var current_power: Power = Power.MINING

@onready var acquired_powers: Dictionary = {
	PICKAXE = 0,
	LADDER = 0,
}
@onready var mining_core:MiningCore = $MiningCore

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if current_power == Power.MINING:
		mining_core.highlight_minable_block()
	pass

func use():
	use_power(current_power)
	pass

func use_power(power: Power):
	match (power):
		Power.MINING:
			mining_core.handle_mining()
	pass
