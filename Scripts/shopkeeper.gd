extends Area2D

@onready var alert: Node2D = $Alert

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		alert.show()


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		alert.hide()
