@tool
class_name KeyObject
extends Node2D

enum KeyObjectType {
	SHOVEL,
	SHIP_KEY,
	BAG,
	JETPACK
}

const KeyObjectTypeDescriptor: Dictionary = {
	KeyObjectType.SHOVEL: "Shovel",
	KeyObjectType.SHIP_KEY: "Ship's key",
	KeyObjectType.BAG: "Bag",
	KeyObjectType.JETPACK: "Jetpack",
}

signal pickup

@export var object_type: KeyObjectType
@export var texture: Texture
@export var font: Font
@export var hover_amplitude: float = 3

@onready var current_sprite: Sprite2D = $Sprite2D

@onready var base_position:Vector2 = position

func _ready() -> void:
	current_sprite.texture = texture

	for key_object_type in KeyObjectType.values():
		assert(
				KeyObjectTypeDescriptor.has(key_object_type),
				"no descriptor for key object type %s" % KeyObjectType.find_key(key_object_type)
		)
	pass

func _draw() -> void:
	if not Engine.is_editor_hint():
		return
	draw_string(font, Vector2.RIGHT*5, KeyObjectType.keys()[object_type], HORIZONTAL_ALIGNMENT_CENTER, 0, 8)

func _on_area_2d_body_entered(body: Node2D):
	if body is Player:
		body.obtain(object_type)
		pickup.emit()
		queue_free()
	pass

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	#hover
	position.y = base_position.y + sin(Time.get_unix_time_from_system()) * hover_amplitude
	pass
