class_name UpgradeMenu
extends Control

const Upgradable := PowerUpgradeLine.Upgradable

@onready var shovel: PowerUpgradeLine = $PauseMenu/PanelContainer/VBoxContainer/Options/Shovel
@onready var jetpack: PowerUpgradeLine = $PauseMenu/PanelContainer/VBoxContainer/Options/Jetpack
@onready var bag: PowerUpgradeLine = $PauseMenu/PanelContainer/VBoxContainer/Options/Bag
@onready var quit: QuitLine = $PauseMenu/PanelContainer/VBoxContainer/Options/Quit

@onready var upgrade_lines: Dictionary[Upgradable, PowerUpgradeLine] = {
	Upgradable.SHOVEL: shovel,
	Upgradable.JETPACK: jetpack,
	Upgradable.BAG: bag,
	Upgradable.NONE: quit,
}

@onready var current_upgrade: Upgradable = Upgradable.SHOVEL

var current_index: int = 0

var current_upgrade_line: PowerUpgradeLine:
	get: return upgrade_lines[current_upgrade]


func _input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("down"):
		select_next_upgrade()
	elif event.is_action_pressed("up"):
		select_previous_upgrade()
	elif event.is_action_pressed("gb_a"):
		current_upgrade_line.activate()


func open_menu() -> void:
	if visible:
		return
	_update_index(current_upgrade)
	GameController.pause()
	show()

func close_menu() -> void:
	if not visible:
		return
	hide()
	GameController.unpause()


func _update_index(selected_upgrade: Upgradable) -> void:
	for upgrade in Upgradable.values():
		var upgrade_line: PowerUpgradeLine = upgrade_lines[upgrade]
		upgrade_line.unfocus()

	current_upgrade = selected_upgrade
	current_upgrade_line.focus()
	current_index = upgrade_lines.keys().find(current_upgrade)
	return

func select_previous_upgrade() -> void:
	var selected_index: int = (current_index + upgrade_lines.size() - 1) % upgrade_lines.size()
	var index_upgrade: Upgradable = upgrade_lines.keys()[selected_index]
	_update_index(index_upgrade)


func select_next_upgrade() -> void:
	var selected_index: int = (current_index + 1) % upgrade_lines.size()
	var index_upgrade: Upgradable = upgrade_lines.keys()[selected_index]
	_update_index(index_upgrade)
	
