class_name CutsceneVictory
extends Cutscene

signal continue_cutscene

# func _unhandled_input(event: InputEvent) -> void:
	# if event.is_action_pressed("gb_a"):
	# 	print("cutscene continue")
	# 	continue_cutscene.emit()

# func play() -> void:
# 	print("victory !")
# 
# 	var children: Array[Node] = get_children()
# 	for c in children:
# 		print("should show ", c)
# 		c.show()
# 		var anim_players: Array[Node] = c.find_children("", "AnimationPlayer")
# 		var anim_player: AnimationPlayer
# 		if not anim_players.is_empty():
# 			anim_player = anim_players.front()
# 			anim_player.play("default")
# 		print("anim_player = ", anim_player)
# 		await continue_cutscene
# 		c.hide()
# 	pass
