class_name JetpackCore
extends AbilityCore

@export var base_power: float = 20.

@onready var flames: AnimatedSprite2D = $Flames

var jetpack_speed: float:
	get: return power_level * base_power

func _ready() -> void:
	flames.hide()

func process(delta: float, powering: bool) -> void:

	if powering:
		player.velocity.y = - player.get_gravity().y * delta - jetpack_speed
		flames.show()
	else:
		flames.hide()
	pass

func boot() -> void:
	# print("boot JETPACK")
	pass

func shutdown() -> void:
	pass

func get_power() -> PowerCore.Power:
	return PowerCore.Power.JETPACK
