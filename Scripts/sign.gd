@tool
class_name Sign
extends Area2D

signal interact

@export var text:String = "Lorem ipsum" 

@onready var message:Control = $HBoxContainer
@onready var label:Label = $HBoxContainer/Label

func _ready() -> void:
	if Engine.is_editor_hint():
		message.show()
	else:
		message.hide()
	label.text = text

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		message.show()


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		message.hide()


func _on_interactible_interact() -> void:
	interact.emit()
