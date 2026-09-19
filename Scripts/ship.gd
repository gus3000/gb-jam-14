extends Node2D

const KeyObjectType := KeyObject.KeyObjectType

const SHOP_MENU: PackedScene = preload("res://Scenes/shop_menu.tscn")

signal shop_reached();
signal shop_left();
signal enter_ship

var overworld : Node

func _ready() -> void:
	overworld = get_tree().get_first_node_in_group("main_scene")
	enter_ship.connect(overworld.enter_ship)

func enter() -> void:
	if not overworld.player.has_key_object(KeyObjectType.SHIP_KEY):
		overworld.ui.queue_string("It's locked")
		return
	enter_ship.emit()
