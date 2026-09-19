extends Node2D



func _on_sign_interact() -> void:
	get_parent().ui.queue_string("Hey Captain !")
	
