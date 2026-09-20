class_name HUD
extends CanvasLayer

const MENU_LABEL_SETTINGS: LabelSettings = preload("res://Resources/LabelSettings/menu_item.tres")
const FOCUS_LABEL_SETTINGS: LabelSettings = preload("res://Resources/LabelSettings/menu_item_focus.tres")

@onready var pause_menu: Control = $PauseMenu
@onready var menu_options: VBoxContainer = $PauseMenu/PanelContainer/VBoxContainer/Options
@onready var music_label: Label = $PauseMenu/PanelContainer/VBoxContainer/Options/Music
@onready var sfx_label: Label = $PauseMenu/PanelContainer/VBoxContainer/Options/SFX

var selected_option: Label
var menu_index := 0
var music_volume := 5
var sfx_volume := 5

func _ready() -> void:
	_update_index(0)
	change_volume(0, true)
	change_volume(0, false)

func _update_index(change: int) -> void:
	menu_index = (menu_index + change) % menu_options.get_child_count()
	selected_option = menu_options.get_child(menu_index) as Label

	for option in menu_options.get_children():
		option.label_settings = MENU_LABEL_SETTINGS

	selected_option.label_settings = FOCUS_LABEL_SETTINGS

func _invoke_option(value: int=0) -> void:
	match menu_index:
		0:
			if value == 0:
				close_menu()
		1:
			if value == 0:
				close_menu()
				await GameController.teleport_to_start()
		2, 3:
			if value == 0:
				value = 1
			change_volume(value, menu_index == 2)

		4:
			get_tree().quit()

func open_menu() -> void:
	_update_index(-menu_index)
	pause_menu.show()
	GameController.pause()

func close_menu() -> void:
	pause_menu.hide()
	GameController.unpause()

func change_volume(value: int, music: bool):
	var volume: int = music_volume if music else sfx_volume
	volume += value
	volume = clamp(volume, 0, 9)
	if music:
		music_volume = volume
		music_label.text = "MUSIC %s" % music_volume
	else:
		sfx_volume = volume
		sfx_label.text = "SFX %s" % sfx_volume

	AudioController.set_volume(volume, music)

	pass

func upgrade_menu_visible() -> bool:
	var upgrade_menu: Node = get_tree().get_first_node_in_group("upgrade_menu")
	if upgrade_menu == null:
		return false
	return upgrade_menu.visible
	

func _unhandled_input(event: InputEvent) -> void:
	if not pause_menu.visible and not upgrade_menu_visible() and event.is_action_pressed("gb_start"):
		open_menu() ;
	elif pause_menu.visible:
		if event.is_action_pressed("gb_a"):
			_invoke_option()
		elif event.is_action_pressed("up"):
			_update_index(-1)
		elif event.is_action_pressed("down"):
			_update_index(1)
		elif event.is_action_pressed("right"):
			_invoke_option(+1)
		elif event.is_action_pressed("left"):
			_invoke_option(-1)

		elif event.is_action_pressed("gb_start"):
			close_menu()
