class_name HUD
extends CanvasLayer

const MENU_LABEL_SETTINGS: LabelSettings = preload("res://Resources/LabelSettings/menu_item.tres")
const FOCUS_LABEL_SETTINGS: LabelSettings = preload("res://Resources/LabelSettings/menu_item_focus.tres")

@onready var pause_menu: Control = $PauseMenu
@onready var menu_options: VBoxContainer = $PauseMenu/PanelContainer/VBoxContainer/Options
@onready var music_label: Label = $PauseMenu/PanelContainer/VBoxContainer/Options/Music

var selected_option: Label
var menu_index := 0
var music_volume := 5

func _ready() -> void:
	_update_index(0)
	change_music_volume(0)

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
		2:
			if value == 0:
				value = 1
			change_music_volume(value)
		3:
			get_tree().quit()

func open_menu() -> void:
	_update_index(-menu_index)
	pause_menu.show()
	GameController.pause()

func close_menu() -> void:
	pause_menu.hide()
	GameController.unpause()

func change_music_volume(value: int):
	music_volume += value
	music_volume = clamp(music_volume, 0, 10)
	print("music volume : ", music_volume)
	music_label.text = "MUSIC\n%s" % music_volume
	AudioController.music.volume_db = (music_volume - 5) * 4 if music_volume > 0 else -80
	pass

func _unhandled_input(event: InputEvent) -> void:
	if not pause_menu.visible and event.is_action_pressed("gb_start"):
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
