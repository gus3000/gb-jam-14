extends Node2D



func _on_sign_interact() -> void:
	GameController.ui.queue_string("Hey Captain !", 1)
	GameController.ui.queue_string("I had big plans\nbut it seems\nthey've\n\"fallen\"\n short")
	
