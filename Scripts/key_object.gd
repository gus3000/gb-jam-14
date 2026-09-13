@tool
class_name KeyObject
extends Node2D

enum KeyObjectType {
	SHIP_KEY
}

@export var object_type: KeyObjectType
@export var texture: Texture
@export var player: Player

@export var font: Font

@onready var current_sprite: Sprite2D = $Sprite2D 

func _ready() -> void:
	current_sprite.texture = texture
	pass

func _draw() -> void:
	if not Engine.is_editor_hint():
		return
	draw_string(font, Vector2.ZERO, KeyObjectType.keys()[object_type], HORIZONTAL_ALIGNMENT_CENTER, 0,8)

func _on_area_2d_body_entered(body: Node2D):
	if body is Player:
		obtain()
	pass

func obtain():
	print("YOU GOT THE ", KeyObjectType.keys()[object_type])
	pass
