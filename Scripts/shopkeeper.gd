extends Node2D



func _on_sign_interact() -> void:
	GameController.ui.queue_string("Hey Captain !")
	
