@tool
class_name EscapePlanetLine
extends PowerUpgradeLine

signal buy

@export var cost: int = 10_000_000

@onready var label: Label = $Label
@onready var amount_label: Label = $Amount

func _ready() -> void:
	amount_label.text = "%s" % cost
	pass

func focus() -> void:
	print("focusing planet escape")
	label.label_settings = focused_label_settings


func unfocus() -> void:
	label.label_settings = unfocused_label_settings


func activate() -> void:
	if GameController.player.gold < cost:
		GameController.player.failed.emit()
		return
	
	GameController.player.gold -= cost
	buy.emit()
