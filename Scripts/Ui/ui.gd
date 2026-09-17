class_name Ui
extends CanvasLayer

const KeyObjectType := KeyObject.KeyObjectType
const KeyObjectTypeDescriptor := KeyObject.KeyObjectTypeDescriptor

enum MessageKey {
	ARBITRARY_TEXT,
	RECEIVED_KEY_OBJECT,
	CYCLE_POWER_REMINDER,
}

@export var message_duration: float = 4.0
@export var messages: Dictionary[MessageKey, String] = {
	MessageKey.RECEIVED_KEY_OBJECT: "Retrieved your\n%s !",
	MessageKey.CYCLE_POWER_REMINDER: "Use SELECT to\ncycle powers",
}

@onready var hud: CanvasLayer = $HUD
@onready var dialog: Control = $Dialog
@onready var label: Label = $Dialog/PanelContainer/MarginContainer/Label
@onready var equipped_power_indicator: UiPowerIcon = $HUD/EquippedPowerIndicator

var message_queue: Array[String] = []

var is_showing_message: bool = false

func _ready() -> void:
	dialog.hide()

func _process(_delta: float) -> void:
	if is_showing_message:
		return

	if not message_queue.is_empty():
		await show_message(message_queue.pop_front())
	pass

func _on_player_obtain_key_object(object_type: KeyObjectType) -> void:
	queue_message(MessageKey.RECEIVED_KEY_OBJECT, [KeyObjectTypeDescriptor[object_type]])
	if GameController.player.power_core.core_for_key_object(object_type) != null:
		queue_message(MessageKey.CYCLE_POWER_REMINDER, [])

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


func _on_player_changed_equipped_power(power:PowerCore.Power) -> void:
	equipped_power_indicator.update_power(power)

func ui_hide() -> void:
	hide()
	hud.hide()

func ui_show() -> void:
	show()
	hud.show()
