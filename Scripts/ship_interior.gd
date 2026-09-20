class_name ShipInterior
extends AbstractLoadableScene

@onready var background: AnimatedSprite2D = $Background
@onready var gold_pan: GoldPan = $GoldPan
@onready var upgrade_menu_interact: InteractPoint = $UpgradeMenuInteract
@onready var upgrade_menu: UpgradeMenu = $UpgradeMenu

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
	GameController.ui.gold.show()
	upgrade_menu_interact.hide()
	if GameController.player.power_core.has_power(PowerCore.Power.JETPACK):
		background.play("SwtichOn")
		GameController.earthquake()
		await background.animation_finished
		# await get_tree().create_timer(3).timeout
		if GameController.player.bag.dirt > 0:
			gold_pan.start()
			await gold_pan.finished
		upgrade_menu_interact.show()
	pass

func on_unload():
	GameController.ui.gold.hide()
	pass

func _on_upgrade_menu_interact() -> void:
	upgrade_menu.open_menu()
	
