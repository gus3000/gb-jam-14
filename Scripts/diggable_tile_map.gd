class_name DiggableTileMap
extends TileMapLayer

enum TerrainType {
	FANCY_STONE,
	STONE,
	BEDROCK,
}

@export var ground_boundaries: Rect2i = Rect2i(0, 8, 50, 50)

var whole_map_pattern: TileMapPattern
var terrains: Dictionary[int, TerrainType] = {}

func _ready():
	whole_map_pattern = TileMapPattern.new()
	for x in range(ground_boundaries.size.x):
		for y in range(ground_boundaries.size.y):
			whole_map_pattern.set_cell(Vector2i(x, y),)

	# sanity check
	for terrain in tile_set.get_terrains_count(0):
		var terrain_name := tile_set.get_terrain_name(0, terrain)

		print("terrain ", terrain_name)
		var type := TerrainType.FANCY_STONE
		match (terrain_name):
			"Fancy Stone":
				type = TerrainType.FANCY_STONE
			"Stone":
				type = TerrainType.STONE
			"Bedrock":
				type = TerrainType.BEDROCK
			_:
				assert(false, "Unknown terrain")
		terrains[terrain] = type


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
	var data := get_cell_tile_data(pos)
	print("cell at %s : %s" % [pos, data.terrain])

	# return Block.new(pos.x, pos.y, (pos.y - ground_boundaries.position.y + 1) * toughness_per_depth_unit)
	return Block.new(pos.x, pos.y, terrains[data.terrain])

# /!\ Resets the ground !
func earthquake() -> void:
	pass
