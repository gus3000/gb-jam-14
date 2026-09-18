extends Node

enum CutsceneType {
	INTRO
}

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cutscene_camera: CameraRig = $Camera2D
@onready var cutscene_node: Dictionary[CutsceneType, Cutscene] = {
	CutsceneType.INTRO: $Cutscenes/Intro
}

# func _ready() -> void:
# 	animation_player.animation_finished.connect(resume_game)

func _process(delta: float) -> void:
	if not OS.is_debug_build():
		return
	if Input.is_physical_key_pressed(KEY_ALT) \
			and Input.is_physical_key_pressed(KEY_KP_4) \
			and not GameController.is_paused():
		play(CutsceneType.INTRO)

func play(cutscene: CutsceneType) -> void:
	GameController.pause()
	GameController.hide_game()
	# var animation_name: String = cutscene_animation[cutscene]
	cutscene_camera.enabled = true
	cutscene_camera.make_current()
	await cutscene_node[cutscene].play()
	# animation_player.play(animation_name)
	# await get_tree().create_timer(3).timeout
	# print("playing anim ", animation_name, " for ", animation_player.current_animation_length, " seconds")
	# await animation_player.animation_finished
	# print("animation finished !")
	GameController.unpause()
	GameController.show_game()


func vibrate() -> void:
	print("VIBRATE")
	cutscene_camera._on_world_shuffle()
	pass