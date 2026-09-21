class_name CutsceneSlideStartMenu
extends CutsceneSlide


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("gb_start"):
		ended.emit()
