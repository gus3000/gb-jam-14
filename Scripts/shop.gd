extends Area2D

@onready var label: Label = $Sign/Label
@onready var camera:Camera2D = $"../../Camera"

const SHOP_MENU = preload("res://Scenes/shop_menu.tscn")

signal shop_reached();
signal shop_left();

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		shop_reached.emit()
		camera.add_child(SHOP_MENU.instantiate())

	
func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		shop_left.emit();
		for child in camera.get_children():
			if child is CanvasLayer:
				child.queue_free()


func _on_sign_body_entered(body: Node2D) -> void:
	if body is Player:
		label.show();


func _on_sign_body_exited(body: Node2D) -> void:
	if body is Player:
		label.hide();
