extends Area2D

const KeyObjectType := KeyObject.KeyObjectType

@onready var label: Label = $Sign/Label
@onready var arrow: Sprite2D = $Sign/Arrow

const SHOP_MENU: PackedScene = preload("res://Scenes/shop_menu.tscn")

signal shop_reached();
signal shop_left();
signal enter_ship

func _ready() -> void:
	enter_ship.connect(GameController.enter_ship)
	label.hide()
	arrow.hide()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		shop_reached.emit()


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		shop_left.emit()


func _on_sign_body_entered(body: Node2D) -> void:
	if body is Player:
		label.show()
		arrow.show()


func _on_sign_body_exited(body: Node2D) -> void:
	if body is Player:
		label.hide()
		arrow.hide()


func enter() -> void:
	if not GameController.player.has_key_object(KeyObjectType.SHIP_KEY):
		GameController.ui.queue_string("It's locked")
		return
	enter_ship.emit()
