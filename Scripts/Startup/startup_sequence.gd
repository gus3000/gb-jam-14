extends Node2D

const STEP_TIME := 0.05
const STEP_SIZE := 4
const TARGET_Y := 56

@export var play_startup_sequence := true

@onready var background: ColorRect = $Background
@onready var nontendo_label: Label = $NontendoLabel
@onready var ninten_ding: AudioStreamPlayer2D = $NintenDing



func _ready():
	descend()
	ninten_ding.play()

func descend() -> void:
	while nontendo_label.position.y < TARGET_Y:
		nontendo_label.position.y += STEP_SIZE
		
		await get_tree().create_timer(STEP_TIME).timeout
		
func _process(delta: float) -> void:
	if ninten_ding.finished:
		nontendo_label.visible = false
