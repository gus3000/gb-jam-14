extends Node2D

const KeyObjectType := KeyObject.KeyObjectType

const SHOP_MENU: PackedScene = preload("res://Scenes/shop_menu.tscn")

signal shop_reached();
signal shop_left();
signal enter_ship

func _ready() -> void:
	enter_ship.connect(GameController.enter_ship)

func enter() -> void:
	if not GameController.player.has_key_object(KeyObjectType.SHIP_KEY):
		GameController.ui.queue_string("It's locked")
		return
	enter_ship.emit()
