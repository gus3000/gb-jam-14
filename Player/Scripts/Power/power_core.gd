class_name PowerCore
extends Node2D

const KeyObjectType := KeyObject.KeyObjectType

enum Power {NONE, SHOVEL, JETPACK}
	
const power_names:Dictionary[Power, String] = {
	Power.NONE: "None",
	Power.SHOVEL: "Shovel",
	Power.JETPACK: "Jetpack",
}

signal changed_equipped_power(power: Power)

@export var current_power: Power = Power.SHOVEL

@onready var player: Player = $".."
@onready var mining_core: MiningCore = $MiningCore
@onready var jetpack_core: JetpackCore = $JetpackCore

@onready var cores: Array[AbilityCore] = [mining_core, jetpack_core]

var equipped_core: AbilityCore:
	get:
		if cores.front().power_level == 0:
			return null
		return cores.front()

var equipped_power: Power:
	get:
		if equipped_core == null:
			return Power.NONE
		return equipped_core.get_power()

var number_of_active_cores: int:
	get:
		var n: int = 0
		for core in cores:
			if core.power_level > 0:
				n += 1
		return n

var powering: bool = false

func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("gb_select"):
		cycle_power()

func _physics_process(delta: float) -> void:
	if equipped_core != null:
		powering = Input.is_action_pressed("gb_b") and equipped_core.power_level > 0
		equipped_core.process(delta, powering)
	pass

func cycle_power(attempts: int=0) -> void:
	if attempts > cores.size():
		# we have no usable power, not even the quipped one
		return
	var core = cores.pop_front()
	core.shutdown()
	cores.push_back(core)

	if equipped_core == null:
		cycle_power(attempts + 1)
		return

	equipped_core.boot()
	changed_equipped_power.emit(equipped_power)

func core_for_key_object(key_object_type: KeyObjectType) -> AbilityCore:
	match (key_object_type):
		KeyObjectType.SHOVEL:
			return mining_core
		KeyObjectType.JETPACK:
			return jetpack_core
		_: return null

func has_power(power: Power) -> bool:
	for core in cores:
		if core.get_power() == power:
			return core.power_level > 0
	return false

func _on_player_obtain_key_object(object_type: KeyObjectType) -> void:
	var core := core_for_key_object(object_type)
	if core == null or core.power_level > 0:
		return
	core.power_level = 1
	cycle_power()
