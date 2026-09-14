class_name MineableTimeMap
extends TileMapLayer

@export var toughness_per_depth_unit: float = 100
@export var starting_layer = 8

func mine_block(block: Block) -> void:
	erase_cell(block.position)

func get_block_map_position(collision_position: Vector2) -> Vector2i:
	var local_collision_pos := to_local(collision_position)
	return local_to_map(local_collision_pos)

func get_block_position(collision_position: Vector2) -> Vector2:
	var map_pos := get_block_map_position(collision_position)
	var local_coords := map_to_local(map_pos)
	var global_coords := to_global(local_coords)

	# print("block : ", local_collision_pos, map_pos, local_coords, global_coords,)
	return global_coords

func get_block_at_point(collision_position: Vector2) -> Block:
	var pos := get_block_map_position(collision_position)
	return Block.new(pos.x, pos.y, (pos.y - starting_layer+1) * toughness_per_depth_unit)
