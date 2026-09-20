class_name JetpackCore
extends AbilityCore

signal started
signal stopped

@export var base_power: float = 20.

@onready var flames: AnimatedSprite2D = $Flames

var was_powering_last_frame: bool = false

var jetpack_speed: float:
	get: return power_level * base_power

func _ready() -> void:
	flames.hide()

func process(delta: float, powering: bool) -> void:
	if powering:
		if not was_powering_last_frame:
			started.emit()
		player.velocity.y = - player.get_gravity().y * delta - jetpack_speed
		flames.show()
		was_powering_last_frame = true
	else:
		if was_powering_last_frame:
			stopped.emit()
		flames.hide()
		was_powering_last_frame = false
	pass

func boot() -> void:
	# print("boot JETPACK")
	pass

func shutdown() -> void:
	flames.hide()
	pass

func get_power() -> PowerCore.Power:
	return PowerCore.Power.JETPACK
