extends Node

enum CutsceneType {
	INTRO
}

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var camera: CameraRig = $Camera2D
@onready var cutscene_node: Dictionary[CutsceneType, Cutscene] = {
	CutsceneType.INTRO: $Cutscenes/Intro
}

var overworld : Node2D
 
func _ready() -> void:
	overworld = get_tree().get_first_node_in_group("main_scene") as Node2D
 	#animation_player.animation_finished.connect(resume_game)

func _process(delta: float) -> void:
	if not OS.is_debug_build():
		return
	if Input.is_physical_key_pressed(KEY_ALT) \
			and Input.is_physical_key_pressed(KEY_KP_4) \
			and not overworld.is_paused():
		play(CutsceneType.INTRO)

func play(cutscene: CutsceneType) -> void:
	overworld.pause()
	overworld.hide_game()
	# var animation_name: String = cutscene_animation[cutscene]
	camera.enabled = true
	camera.make_current()
	await cutscene_node[cutscene].play()
	# animation_player.play(animation_name)
	# await get_tree().create_timer(3).timeout
	# print("playing anim ", animation_name, " for ", animation_player.current_animation_length, " seconds")
	# await animation_player.animation_finished
	# print("animation finished !")
	overworld.unpause()
	overworld.show_game()


func vibrate() -> void:
	print("VIBRATE")
	camera._on_world_shuffle()
	pass
