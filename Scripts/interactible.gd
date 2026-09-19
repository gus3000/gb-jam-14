class_name Interactible
extends Area2D

signal interact

func _physics_process(_delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if not overlaps_body(player):
		return
	
	if Input.is_action_just_pressed("up"):
		print("interact !")
		interact.emit()
