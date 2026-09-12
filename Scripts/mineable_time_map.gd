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
	var local_collision_pos := to_local(collision_position)
	var map_pos := local_to_map(local_collision_pos)
	print(map_pos)
	erase_cell(map_pos)

func get_block_position(collision_position: Vector2) -> Vector2:
	var local_collision_pos := to_local(collision_position)
	var map_pos := local_to_map(local_collision_pos)
	var local_coords := map_to_local(map_pos)
	var global_coords := to_global(local_coords)

	print("block : ", local_collision_pos, map_pos, local_coords, global_coords,)
	return global_coords
