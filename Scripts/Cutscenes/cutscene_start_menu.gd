class_name CutsceneStartMenu
extends Cutscene

func _ready() -> void:
	cutscene_ended.connect(start_intro)

func start_intro() -> void:
	CutsceneController.play.call_deferred(CutsceneController.CutsceneType.INTRO)