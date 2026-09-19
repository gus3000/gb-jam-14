extends Control

@onready var start: Label = $MarginContainer/PanelContainer/Start
@onready var gameboy_shader: ColorRect = $"Gameboy Shader"
const FADE_STEP := 0.25
const FADE_TIME := 0.35

var is_fading := false


func _process(delta: float) -> void:
	if is_fading:
		return
		
	if Input.is_action_just_pressed("gb_a") or Input.is_action_just_pressed("gb_start"):
		fade_out()


func fade_out() -> void:
	start.text = "Stay Golden!"
	while gameboy_shader.modulate.a > 0.0:
		await get_tree().create_timer(FADE_TIME).timeout
		gameboy_shader.modulate.a = max(gameboy_shader.modulate.a - FADE_STEP, 0.0)
		
	await get_tree().create_timer(FADE_TIME).timeout
	get_tree().change_scene_to_file("res://Scenes/overworld.tscn")
