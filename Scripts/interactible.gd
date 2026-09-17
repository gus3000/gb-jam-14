class_name Interactible
extends Area2D

signal interact

func _physics_process(_delta: float) -> void:
	var player: Player = GameController.player
	if not overlaps_body(player):
		return
	
	if Input.is_action_just_pressed("up"):
		print("interact !")
		interact.emit()
