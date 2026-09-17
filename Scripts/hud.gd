class_name HUD
extends CanvasLayer

const MENU_LABEL_SETTINGS: LabelSettings = preload("res://Resources/LabelSettings/menu_item.tres")
const FOCUS_LABEL_SETTINGS: LabelSettings = preload("res://Resources/LabelSettings/menu_item_focus.tres")

@onready var pause_menu: Control = $PauseMenu
@onready var menu_options: VBoxContainer = $PauseMenu/PanelContainer/VBoxContainer/Options

var selected_option: Label
var menu_index := 0

func _ready() -> void:
	_update_index(0)

func _update_index(change: int) -> void:
	menu_index = (menu_index + change) % menu_options.get_child_count()
	selected_option = menu_options.get_child(menu_index) as Label

	for option in menu_options.get_children():
		option.label_settings = MENU_LABEL_SETTINGS

	selected_option.label_settings = FOCUS_LABEL_SETTINGS

func _invoke_option() -> void:
	match menu_index:
		0:
			close_menu()
		1:
			close_menu()
		2:
			close_menu()
		3:
			get_tree().quit()

func open_menu() -> void:
	_update_index(-menu_index)
	pause_menu.show()
	GameController.pause()

func close_menu() -> void:
	pause_menu.hide()
	GameController.unpause()

func _unhandled_input(event: InputEvent) -> void:
	if not pause_menu.visible and event.is_action_pressed("gb_start"):
		open_menu() ;
	else:
		if event.is_action_pressed("gb_a"):
			_invoke_option()
		elif event.is_action_pressed("up"):
			_update_index(-1)
		elif event.is_action_pressed("down"):
			_update_index(1)
		elif event.is_action_pressed("gb_start"):
			close_menu()
