class_name Helmet
extends Area2D

## in milliseconds
@export var break_block_threshold: float = 500.0

@onready var mining_core: MiningCore = $"../PowerCore/MiningCore"

func _on_body_entered(body: Node2D) -> void:
	print("helmet : body entered : ", body)
	if is_instance_of(body, DiggableTileMap):
		print("bonk the block")
		var helmet_grid_pos: Vector2i = body.get_block_map_position(global_position)
		# print("helmet is at ", helmet_grid_pos)
		var block_grid_pos: Vector2i = helmet_grid_pos + Vector2i.UP
		var block: Block = body.get_block_at_map_position(block_grid_pos)
		if block == null:
			return
	
		print("block mining time : %s, threshold = %s" % [mining_core.mining_time(block), break_block_threshold])
		if mining_core.mining_time(block) <= break_block_threshold:
			body.mine_block(block)
			mining_core.block_mined.emit(block)
		else:
			GameController.player.failed.emit()
