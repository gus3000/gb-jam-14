class_name Ui
extends CanvasLayer

const KeyObjectType := KeyObject.KeyObjectType
const KeyObjectTypeDescriptor := KeyObject.KeyObjectTypeDescriptor

enum MessageKey {
	ARBITRARY_TEXT,
	RECEIVED_KEY_OBJECT,
	CYCLE_POWER_REMINDER,
}

class Message:
	var text: String
	var duration: float
	func _init(_text: String, _duration: float) -> void:
		text = _text
		duration = _duration

const message_duration: float = 4.0
@export var messages: Dictionary[MessageKey, String] = {
	MessageKey.RECEIVED_KEY_OBJECT: "Retrieved your\n%s !",
	MessageKey.CYCLE_POWER_REMINDER: "Use SELECT to\ncycle powers",
}

@onready var hud: CanvasLayer = $HUD
@onready var dialog: Control = $Dialog
@onready var label: Label = $Dialog/PanelContainer/MarginContainer/Label
@onready var equipped_power_indicator: UiPowerIcon = $HUD/EquippedPowerIndicator
@onready var gold: Label = $Gold

var message_queue: Array[Message] = []

var is_showing_message: bool = false

func _ready() -> void:
	dialog.hide()
	GameController.gold_changed.connect(_on_gold_change)

func _process(_delta: float) -> void:
	if is_showing_message:
		return

	if not message_queue.is_empty():
		await show_message(message_queue.pop_front())
	pass

func queue_string(message: String, duration: float=message_duration):
	message_queue.push_back(Message.new(message, duration))

func queue_message(messageKey: MessageKey, context: Array=[], duration: float=message_duration) -> void:
	queue_string(messages[messageKey] % context, duration)
	pass

func show_message(message: Message) -> void:
	print("start message : ", message)
	is_showing_message = true
	dialog.show()
	label.text = message.text
	await get_tree().create_timer(message.duration).timeout
	print("end message : ", message)
	is_showing_message = false
	dialog.hide()

func ui_hide() -> void:
	hide()
	hud.hide()

func ui_show() -> void:
	show()
	hud.show()

func _on_player_obtain_key_object(object_type: KeyObjectType) -> void:
	queue_message(MessageKey.RECEIVED_KEY_OBJECT, [KeyObjectTypeDescriptor[object_type]])
	if GameController.player.power_core.core_for_key_object(object_type) != null \
			and GameController.player.power_core.number_of_active_cores > 1:
		queue_message(MessageKey.CYCLE_POWER_REMINDER, [])


func _on_player_changed_equipped_power(power: PowerCore.Power) -> void:
	equipped_power_indicator.update_power(power)

func _on_gold_change(new_amount: int) -> void:
	print("ui gold changed to ", new_amount)
	gold.text = "%s$" % Utils.format_int(new_amount)
	pass
