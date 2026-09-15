class_name ShipInterior
extends Node2D


func _on_exit_body_entered(body: Node2D) -> void:
	print("exit collides with ", body)
	if not is_instance_of(body, Player):
		return
	print("leave ship")
	GameController.leave_ship()
