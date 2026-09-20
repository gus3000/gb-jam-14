class_name UpgradeMenu
extends Control

const Upgradable := PowerUpgradeLine.Upgradable

@onready var shovel: PowerUpgradeLine = $PauseMenu/PanelContainer/VBoxContainer/Options/Shovel
@onready var jetpack: PowerUpgradeLine = $PauseMenu/PanelContainer/VBoxContainer/Options/Jetpack
@onready var bag: PowerUpgradeLine = $PauseMenu/PanelContainer/VBoxContainer/Options/Bag
@onready var escape_planet: EscapePlanetLine = $PauseMenu/PanelContainer/VBoxContainer/Options/EscapePlanet
@onready var quit: QuitLine = $PauseMenu/PanelContainer/VBoxContainer/Options/Quit

@onready var upgrade_lines: Dictionary[Upgradable, PowerUpgradeLine] = {
	Upgradable.SHOVEL: shovel,
	Upgradable.JETPACK: jetpack,
	Upgradable.BAG: bag,
	Upgradable.ESCAPE_PLANET: escape_planet,
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
	elif event.is_action_pressed("gb_a") or event.is_action_pressed("gb_start"):
		accept_event()
		current_upgrade_line.activate()
		escape_planet.visible = GameController.player.can_buy_escape()
	elif event.is_action_pressed("gb_b"):
		close_menu()


func open_menu() -> void:
	if visible:
		return
	_update_index(current_upgrade)
	GameController.pause()
	show()
	escape_planet.visible = GameController.player.can_buy_escape()


func close_menu() -> void:
	if not visible:
		return
	hide()
	GameController.unpause.call_deferred()


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
	if not GameController.player.can_buy_escape() and index_upgrade == Upgradable.ESCAPE_PLANET:
		select_previous_upgrade()


func select_next_upgrade() -> void:
	var selected_index: int = (current_index + 1) % upgrade_lines.size()
	var index_upgrade: Upgradable = upgrade_lines.keys()[selected_index]
	_update_index(index_upgrade)

	if not GameController.player.can_buy_escape() and index_upgrade == Upgradable.ESCAPE_PLANET:
		select_next_upgrade()


func _on_escape_planet_buy() -> void:
	close_menu()
	GameController.win()
