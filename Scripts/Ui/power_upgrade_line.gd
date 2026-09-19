@tool
class_name PowerUpgradeLine
extends HBoxContainer

enum Upgradable {
	SHOVEL,
	JETPACK,
	BAG,
}

@export var upgrade_type:Upgradable

@onready var power_label: Label = $PowerLabel
@onready var level: Label = $Level

func _ready() -> void:
	power_label.text = str(Upgradable.keys()[upgrade_type])
	level.text = "0"

func get_level()->int:
	return 0
