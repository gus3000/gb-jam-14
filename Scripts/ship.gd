extends Area2D

@onready var label: Label = $Sign/Label
@onready var arrow: Sprite2D = $Sign/Arrow
@onready var camera:Camera2D = $"../../Camera"

const SHOP_MENU: PackedScene = preload("res://Scenes/shop_menu.tscn")

signal shop_reached();
signal shop_left();
signal enter_ship

func _ready() -> void:
	enter_ship.connect(GameController.earthquake)
	label.hide()
	arrow.hide()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		shop_reached.emit()
		# camera.add_child(SHOP_MENU.instantiate())


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		shop_left.emit()
		# for child in camera.get_children():
		# 	if child is CanvasLayer:
		# 		child.queue_free()


func _on_sign_body_entered(body: Node2D) -> void:
	if body is Player:
		label.show()
		arrow.show()


func _on_sign_body_exited(body: Node2D) -> void:
	if body is Player:
		label.hide()
		arrow.hide()


func enter() -> void:
	enter_ship.emit()
