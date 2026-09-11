class_name MineableTimeMap
extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# func get_block(collision_position: Vector2)->Block:
# 	var local_pos = local_to_map(collision_position)


func mine_block(collision_position: Vector2) -> void:
	var global_collision_pos = to_local(collision_position)
	var local_pos = local_to_map(global_collision_pos)
	print(local_pos)
	erase_cell(local_pos)
