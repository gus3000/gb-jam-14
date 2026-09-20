@tool
class_name PowerUpgradeLine
extends Control

const Power := PowerCore.Power

enum Upgradable {
	NONE,
	SHOVEL,
	JETPACK,
	BAG,
	ESCAPE_PLANET,
}

const UpgradeCost: Dictionary[Upgradable, Array] = {
	Upgradable.SHOVEL: [0, 1000, 5000, 25_000, 100_000, 1_000_000],
	Upgradable.JETPACK: [0, 1000, 4000, 10_000, 20_000, 50_000],
	Upgradable.BAG: [0, 2000, 8000, 20_000, 40_000, 100_000],
}

var focused_label_settings: LabelSettings = preload("res://Resources/LabelSettings/menu_item_focus.tres")
var unfocused_label_settings: LabelSettings = preload("res://Resources/LabelSettings/menu_item.tres")

@export var upgrade_type: Upgradable

@onready var power_label: Label
@onready var level_label: Label
@onready var cost_label: Label

func _ready() -> void:
	power_label = $PowerLabel
	level_label = $Level
	cost_label = $Cost

	update_line()

func update_line() -> void:
	power_label.text = str(Upgradable.keys()[upgrade_type])
	if get_level() == get_power_node().max_power_level:
		level_label.text = "M"
		cost_label.text = "-"
		return

	level_label.text = "%s" % get_level()
	cost_label.text = "%s" % Utils.format_int(get_cost())

func get_power_node() -> Node2D:
	match (upgrade_type):
		Upgradable.SHOVEL: return GameController.player.power_core.mining_core
		Upgradable.JETPACK: return GameController.player.power_core.jetpack_core
		Upgradable.BAG: return GameController.player.bag
		_: return null

func get_level() -> int:
	var power_node: Node2D = get_power_node()
	if power_node == null:
		return 0
	return power_node.power_level

func get_cost(level=-1) -> int:
	if upgrade_type == Upgradable.NONE:
		return -1
	if level < 0:
		level = get_level()
	return UpgradeCost[upgrade_type][level]

func focus() -> void:
	# print("focusing ", power_label.text)
	power_label.label_settings = focused_label_settings

func unfocus() -> void:
	# print("unfocusing ", power_label.text)
	power_label.label_settings = unfocused_label_settings

func activate() -> void:
	print("upgrade ", power_label.text)
	var cost: int = get_cost()
	if GameController.player.gold < cost:
		GameController.player.failed.emit()
		return

	GameController.player.gold -= cost
	get_power_node().power_level += 1
	update_line()
