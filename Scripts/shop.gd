extends Area2D

@onready var label: Label = $Sign/Label

const SHOP_MENU = preload("res://Scenes/shop_menu.tscn")

signal shop_reached();
signal shop_left();

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		shop_reached.emit()
		get_parent().get_node("Camera").add_child(SHOP_MENU.instantiate())

	
func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		shop_left.emit();
		for child in get_parent().get_node("Camera").get_children():
			if child is CanvasLayer:
				child.queue_free()


func _on_sign_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		label.show();


func _on_sign_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		label.hide();
