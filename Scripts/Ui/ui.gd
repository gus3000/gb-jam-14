class_name Ui
extends CanvasLayer

const KeyObjectType := KeyObject.KeyObjectType
const KeyObjectTypeDescriptor := KeyObject.KeyObjectTypeDescriptor

const MAX_LINE_LENGTH: int = 17

enum MessageKey {
	ARBITRARY_TEXT,
	RECEIVED_KEY_OBJECT,
	CYCLE_POWER_REMINDER,
}

signal ui_accept
signal ui_move
signal ui_fail

const message_duration: float = 4.0
@export var messages: Dictionary[MessageKey, String] = {
	MessageKey.RECEIVED_KEY_OBJECT: "Retrieved your\n%s !",
	MessageKey.CYCLE_POWER_REMINDER: "Use SELECT to\ncycle powers",
}

@onready var hud: CanvasLayer = $HUD
@onready var dialog: Control = $Dialog
@onready var arrow: TextureRect = $Dialog/PanelContainer/MarginContainer/Arrow
@onready var label: Label = $Dialog/PanelContainer/MarginContainer/Label
@onready var equipped_power_indicator: UiPowerIcon = $HUD/EquippedPowerIndicator
@onready var gold: Label = $Gold

var message_queue: Array[String] = []

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

func _unhandled_input(event: InputEvent) -> void:
	if is_showing_message and (
			event.is_action_pressed("gb_a") \
			or event.is_action_pressed("gb_b") \
			or event.is_action_pressed("gb_start")
	):
		print("ui accept")
		ui_accept.emit()

func queue_string(message: String) -> void:
	message_queue.push_back(message)

func queue_message_key(messageKey: MessageKey, context: Array=[]) -> void:
	queue_string(messages[messageKey] % context)
	pass

func show_message(text: String) -> void:
	print("start message : ", text)
	is_showing_message = true
	dialog.show()
	label.text = text
	GameController.pause()
	#TODO put small arrow
	# await get_tree().create_timer(message.duration).timeout
	await ui_accept
	GameController.unpause.call_deferred()
	print("end message : ", text)
	is_showing_message = false
	dialog.hide()

func ui_hide() -> void:
	hide()
	hud.hide()

func ui_show() -> void:
	show()
	hud.show()

func _on_player_obtain_key_object(object_type: KeyObjectType) -> void:
	queue_message_key(MessageKey.RECEIVED_KEY_OBJECT, [KeyObjectTypeDescriptor[object_type]])
	if GameController.player.power_core.core_for_key_object(object_type) != null \
			and GameController.player.power_core.number_of_active_cores > 1:
		queue_message_key(MessageKey.CYCLE_POWER_REMINDER, [])


func _on_player_changed_equipped_power(power: PowerCore.Power) -> void:
	equipped_power_indicator.update_power(power)

func _on_gold_change(new_amount: int) -> void:
	print("ui gold changed to ", new_amount)
	gold.text = "%s$" % Utils.format_int(new_amount)
	pass
