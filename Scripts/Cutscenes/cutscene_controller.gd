extends Node

const CutsceneType := Cutscene.CutsceneType

signal cutscene_starts_playing(cutscene: CutsceneType)
signal cutscene_stops_playing(cutscene: CutsceneType)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cutscene_camera: CameraRig = $Camera2D
@onready var cutscene_node: Dictionary[CutsceneType, Cutscene] = {
	CutsceneType.START_MENU: $Cutscenes/StartMenu,
	CutsceneType.INTRO: $Cutscenes/Intro,
	CutsceneType.VICTORY: $Cutscenes/Victory
}

var current_cutscene: Cutscene = null
var is_playing_any_cutscene: bool:
	get: return current_cutscene != null

func _ready() -> void:
	play.call_deferred(CutsceneType.START_MENU)
	await cutscene_stops_playing
	GameController.ui.queue_string("What a landing !")
	GameController.ui.queue_string("I hope\nmy friend\nis okay.")
	GameController.ui.queue_string("And the ship.")
	GameController.ui.queue_string("...probably\nnot.")

func _process(delta: float) -> void:
	if not OS.is_debug_build():
		return
	if Input.is_physical_key_pressed(KEY_ALT) \
			and Input.is_physical_key_pressed(KEY_KP_4) \
			and not GameController.is_paused():
		play(CutsceneType.INTRO)

func play(cutscene: CutsceneType) -> void:
	var cutscene_to_play: Cutscene = cutscene_node[cutscene]
	if cutscene_to_play.is_playing:
		return
	GameController.pause()
	GameController.hide_game()
	# var animation_name: String = cutscene_animation[cutscene]
	cutscene_camera.enabled = true
	cutscene_camera.make_current()
	current_cutscene = cutscene_to_play
	cutscene_starts_playing.emit(cutscene)
	await current_cutscene.play()
	cutscene_stops_playing.emit(cutscene)
	current_cutscene = null
	# animation_player.play(animation_name)
	# await get_tree().create_timer(3).timeout
	# print("playing anim ", animation_name, " for ", animation_player.current_animation_length, " seconds")
	# await animation_player.animation_finished
	# print("animation finished !")
	GameController.unpause()
	GameController.show_game()

func skip() -> void:
	if current_cutscene == null:
		return
	current_cutscene.skip()
	pass

func vibrate() -> void:
	cutscene_camera._on_world_shuffle()
	pass
