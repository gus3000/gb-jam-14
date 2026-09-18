class_name ShipInterior
extends AbstractLoadableScene

@onready var background: AnimatedSprite2D = $Background
@onready var gold_pan: GoldPan = $GoldPan

func _on_exit_body_entered(body: Node2D) -> void:
	if not GameController.player.power_core.has_power(PowerCore.Power.JETPACK):
		return
	# print("exit collides with ", body)
	if not is_instance_of(body, Player):
		return
	# print("leave ship")
	GameController.leave_ship()


func _on_key_object_pickup() -> void:
	GameController.player.movement_paused = true
	await blink()
	GameController.earthquake()
	await get_tree().create_timer(3).timeout
	GameController.player.movement_paused = false


func blink() -> void:
	background.play("SwtichOn")
	await background.animation_finished
	pass

func on_load():
	gold_pan.start()
	pass
func on_unload():
	pass
