class_name PowerCore
extends Node2D

enum Power {MINING, LADDER}

@export var current_power: Power = Power.MINING

@onready var acquired_powers: Dictionary = {
	PICKAXE = 0,
	LADDER = 0,
}
@onready var mining_core: MiningCore = $MiningCore

var powering: bool = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	powering = Input.is_action_pressed("gb_b")

	match current_power:
		Power.MINING:
			mining_core.process(powering)
		Power.LADDER:
			pass
	pass
