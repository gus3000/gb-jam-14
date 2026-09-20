class_name Cutscene
extends Node2D

enum CutsceneType {
	INTRO,
	VICTORY,
}

signal slide_ended

const DEFAULT_DURATION:float = 3
var duration: float = 3
var should_skip: bool = false

var is_playing: bool = false
var slide_started_at: float = 0

func skip() -> void:
	should_skip = true
	slide_started_at = 0
	slide_ended.emit()

func _process(delta: float) -> void:
	var current_time: float = Time.get_unix_time_from_system()
	if is_playing and current_time - slide_started_at >= duration:
		slide_ended.emit()

func play() -> void:
	# print("starting cutscene ", name)
	is_playing = true
	show()
	var children: Array[Node] = get_children()
	print("%s slides to show" % children.size())
	for c in children:
		if should_skip:
			continue
		print("should show ", c)
		c.show()
		var anim_players: Array[Node] = c.find_children("", "AnimationPlayer")
		var anim_player: AnimationPlayer
		if not anim_players.is_empty():
			anim_player = anim_players.front()
			anim_player.play("default")
			anim_player.animation_finished.connect(_slide_ended_cause_animation_finished)
			duration = 1000
		else:
			duration = DEFAULT_DURATION
		# print("anim_player = ", anim_player)
		slide_started_at = Time.get_unix_time_from_system()
		# await get_tree().create_timer(3).timeout
		await slide_ended
		c.hide()

	hide()
	slide_started_at = 0
	should_skip = false
	is_playing = false
# print("ending cutscene ", name)

func _slide_ended_cause_animation_finished(_whatever) -> void:
	slide_ended.emit()
