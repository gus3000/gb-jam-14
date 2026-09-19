extends Control

const STEP_TIME := 0.05
const STEP_SIZE := 4
const TARGET_Y := 48

@export var play_startup_sequence := true

@onready var background: ColorRect = $Background
@onready var nontendo_label: Label = $NontendoLabel
@onready var nonten_ding: AudioStreamPlayer2D = $NintenDing

signal finished

var loaded := false

func _ready():
	descend()

func descend() -> void:
	while nontendo_label.position.y < TARGET_Y:
		nontendo_label.position.y += STEP_SIZE
		await get_tree().create_timer(STEP_TIME).timeout
	await get_tree().create_timer(STEP_TIME).timeout
	
	nonten_ding.play()
	await nonten_ding.finished
		
	nontendo_label.visible = false
	await get_tree().create_timer(STEP_TIME).timeout
	
	get_tree().change_scene_to_file("res://Scenes/home_menu.tscn")
