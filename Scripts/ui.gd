class_name Ui
extends CanvasLayer

const KeyObjectType := KeyObject.KeyObjectType
const KeyObjectTypeDescriptor := KeyObject.KeyObjectTypeDescriptor

enum MessageKey {
	ARBITRARY_TEXT,
	RECEIVED_KEY_OBJECT,
}

@export var message_duration: float = 2.0
@export var messages: Dictionary[MessageKey, String] = {
	MessageKey.RECEIVED_KEY_OBJECT: "Retrieved your\n%s !",
}

@onready var dialog: Control = $Dialog
@onready var label: Label = $Dialog/PanelContainer/MarginContainer/Label
@onready var power_icon: UiPowerIcon = $PowerIcon

var message_queue: Array[String] = []

var is_showing_message: bool = false

func _ready() -> void:
	dialog.hide()

func _process(delta: float) -> void:
	if is_showing_message:
		return

	if not message_queue.is_empty():
		await show_message(message_queue.pop_front())
	pass

func _on_player_obtain_key_object(object_type: KeyObjectType) -> void:
	queue_message(MessageKey.RECEIVED_KEY_OBJECT, [KeyObjectTypeDescriptor[object_type]])

func queue_string(message: String):
	message_queue.push_back(message)

func queue_message(messageKey: MessageKey, context: Array=[]) -> void:
	# print(messages[messageKey] % context)
	message_queue.push_back(messages[messageKey] % context)
	pass

func show_message(message: String) -> void:
	print("start message : ", message)
	is_showing_message = true
	dialog.show()
	label.text = message
	await get_tree().create_timer(message_duration).timeout
	print("end message : ", message)
	is_showing_message = false
	dialog.hide()


func _on_player_changed_equipped_core(ability_core: AbilityCore) -> void:
	pass
