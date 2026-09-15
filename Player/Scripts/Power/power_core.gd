class_name PowerCore
extends Node2D

const KeyObjectType := KeyObject.KeyObjectType

enum Power {MINING, JETPACK}



@export var current_power: Power = Power.MINING

@onready var player:Player = $".."
@onready var mining_core: MiningCore = $MiningCore
@onready var jetpack_core: JetpackCore = $JetpackCore

@onready var cores: Array[AbilityCore] = [mining_core, jetpack_core]

var equipped_core: AbilityCore:
	get: return cores.front()

var powering: bool = false

func _ready() -> void:
	pass

func cycle_power() -> void:
	var core = cores.pop_front()
	core.shutdown()
	cores.push_back(core)
	if equipped_core.power_level == 0:
		cycle_power()
		return
	equipped_core.boot()
	player.changed_equipped_core.emit(equipped_core)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("gb_select"):
		cycle_power()

func _physics_process(delta: float) -> void:
	powering = Input.is_action_pressed("gb_b")
	equipped_core.process(delta, powering)
	pass
