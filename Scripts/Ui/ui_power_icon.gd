class_name UiPowerIcon
extends Control

const Power := PowerCore.Power

@onready var shovel_rect: TextureRect = $PanelContainer/Pickaxe
@onready var jetpack_rect: TextureRect = $PanelContainer/Jetpack

@onready var power_icons: Dictionary[Power, TextureRect] = {
	Power.SHOVEL: shovel_rect,
	Power.JETPACK: jetpack_rect
}

func _ready() -> void:
	update_power(Power.NONE)

func update_power(power: Power):
	print("power icon has to change to ", power)
	for p in power_icons.keys():
		power_icons[p].visible = p == power
	pass
