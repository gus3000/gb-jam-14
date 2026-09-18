class_name Cutscene
extends Node2D

func play() -> void:
	print("starting cutscene ", name)

	var children: Array[Node] = get_children()
	for c in children:
		print("should show ", c)
		c.show()
		var anim_players: Array[Node] = c.find_children("", "AnimationPlayer")
		var anim_player: AnimationPlayer
		if not anim_players.is_empty():
			anim_player = anim_players.front()
			anim_player.play("default")
		print("anim_player = ", anim_player)
		await get_tree().create_timer(3).timeout
		c.hide()

	print("ending cutscene ", name)
