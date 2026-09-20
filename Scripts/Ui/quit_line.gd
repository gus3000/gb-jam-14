@tool
class_name QuitLine
extends PowerUpgradeLine

signal quit

@onready var label:Label = $"."

func _ready() -> void:
	pass

func focus() -> void:
	# print("focusing ", power_label.text)
	label.label_settings = focused_label_settings

func unfocus() -> void:
	# print("unfocusing ", power_label.text)
	label.label_settings = unfocused_label_settings

func activate() -> bool:
	quit.emit()
	return true
