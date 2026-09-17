@tool
class_name InteractPoint
extends Area2D

signal focused(sign: InteractPoint)
signal unfocused(sign: InteractPoint)
signal interact

@export var text: String = "Lorem ipsum"

@onready var message: Control = $HBoxContainer
@onready var label: Label = $HBoxContainer/Label
@onready var shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	focused.connect(GameController.camera.focus)
	unfocused.connect(GameController.camera.unfocus)
	if Engine.is_editor_hint():
		message.show()
	else:
		message.hide()
	label.text = text

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		message.show()
		focused.emit(self)


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		message.hide()
		unfocused.emit(self)


func _on_interactible_interact() -> void:
	interact.emit()
