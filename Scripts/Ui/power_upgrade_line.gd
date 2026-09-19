@tool
class_name PowerUpgradeLine
extends Control

enum Upgradable {
	NONE,
	SHOVEL,
	JETPACK,
	BAG,
}

var focused_label_settings: LabelSettings = preload("res://Resources/LabelSettings/menu_item_focus.tres")
var unfocused_label_settings: LabelSettings = preload("res://Resources/LabelSettings/menu_item.tres")

@export var upgrade_type: Upgradable

@onready var power_label: Label
@onready var level: Label

func _ready() -> void:
	power_label = $PowerLabel
	level = $Level
	
	power_label.text = str(Upgradable.keys()[upgrade_type])
	level.text = "0"

func get_level() -> int:
	return 0

func focus() -> void:
	# print("focusing ", power_label.text)
	power_label.label_settings = focused_label_settings

func unfocus() -> void:
	# print("unfocusing ", power_label.text)
	power_label.label_settings = unfocused_label_settings

func activate() -> void:
	print("upgrade ", power_label.text)
