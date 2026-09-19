class_name ShipInterior
extends AbstractLoadableScene

@onready var background: AnimatedSprite2D = $Background
@onready var gold_pan: GoldPan = $GoldPan

var overworld : Node2D

func _ready() -> void:
	overworld = get_parent()
	
func _on_exit_body_entered(body: Node2D) -> void:
	if not overworld.player.power_core.has_power(PowerCore.Power.JETPACK):
		return
	# print("exit collides with ", body)
	if not is_instance_of(body, Player):
		return
	# print("leave ship")
	overworld.leave_ship()


func _on_key_object_pickup() -> void:
	overworld.player.movement_paused = true
	await blink()
	overworld.earthquake()
	await get_tree().create_timer(3).timeout
	overworld.player.movement_paused = false


func blink() -> void:
	background.play("SwtichOn")
	await background.animation_finished
	pass

func on_load():
	overworld.ui.gold.show()
	if overworld.player.power_core.has_power(PowerCore.Power.JETPACK):
		background.play("SwtichOn")
		await background.animation_finished
		overworld.earthquake()
		await get_tree().create_timer(3).timeout
		if overworld.player.bag.dirt > 0:
			gold_pan.start()
	pass

func on_unload():
	overworld.ui.gold.hide()
	pass
