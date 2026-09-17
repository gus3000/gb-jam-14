extends Node

enum Cutscene {
	INTRO
}

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cutscene_camera: Camera2D = $Camera2D
var cutscene_animation: Dictionary[Cutscene, String] = {
	Cutscene.INTRO: "Intro"
}

# func _ready() -> void:
# 	animation_player.animation_finished.connect(resume_game)

func _process(delta: float) -> void:
	if not OS.is_debug_build():
		return
	if Input.is_physical_key_pressed(KEY_ALT) \
			and Input.is_physical_key_pressed(KEY_KP_4) \
			and not animation_player.is_playing():
		play(Cutscene.INTRO)
	elif animation_player.is_playing():
		print("animation playing")
# animation_player.

func play(cutscene: Cutscene) -> void:
	GameController.pause()
	GameController.hide_game()
	var animation_name: String = cutscene_animation[cutscene]
	cutscene_camera.enabled = true
	cutscene_camera.make_current()
	animation_player.play(animation_name)
	print("playing anim ", animation_name, " for ", animation_player.current_animation_length, " seconds")
	await animation_player.animation_finished
	print("animation finished !")
	GameController.unpause()
	GameController.show_game()


	# func resume_game(_finished_animation: String) -> void:
	# 	print("animation finished !")
	# 	GameController.unpause()
	# 	GameController.show_game()
