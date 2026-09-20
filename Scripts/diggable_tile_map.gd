class_name DiggableTileMap
extends TileMapLayer

enum TerrainType {
	FANCY_STONE,
	STONE,
	BEDROCK,
}

@export var ground_boundaries: Rect2i = Rect2i(0, 8, 112, 57)

# var whole_map_pattern: TileMapPattern
var crust_pattern: TileMapPattern
var terrains: Dictionary[int, TerrainType] = {}

func _ready():
	GameController.world_shuffle.connect(earthquake)

	crust_pattern = TileMapPattern.new()

	var crust_line: Array[Vector2i] = []
	for x in range(ground_boundaries.size.x):
		crust_line.push_back(Vector2i(ground_boundaries.position.x + x, ground_boundaries.position.y))
	crust_pattern = get_pattern(crust_line)

	# whole_map_pattern = TileMapPattern.new()
	# for x in range(ground_boundaries.size.x):
	# 	for y in range(ground_boundaries.size.y):
	# 		whole_map_pattern.set_cell(Vector2i(x, y),)

	# sanity check
	for terrain in tile_set.get_terrains_count(0):
		var terrain_name := tile_set.get_terrain_name(0, terrain)

		# print("terrain ", terrain_name)
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
	return get_block_at_map_position(pos)


func get_block_at_map_position(map_pos: Vector2i) -> Block:
	var data := get_cell_tile_data(map_pos)
	if data == null:
		return null
	var terrain := data.terrain
	if terrain < 0:
		terrain = TerrainType.BEDROCK
	var multiplier = data.get_custom_data("multiplier")
	# print("cell at %s : %s (x%s)" % [pos, data.terrain, multiplier])

	# return Block.new(pos.x, pos.y, (pos.y - ground_boundaries.position.y + 1) * toughness_per_depth_unit)
	return Block.new(map_pos.x, map_pos.y, terrains[terrain], multiplier)

func adjust_probabilites(base_probabilities: Array[float], depth: int) -> Array[float]:
	return [
		base_probabilities[0],
		base_probabilities[1] * pow(depth, .1),
		base_probabilities[2] * pow(depth, .5),
		base_probabilities[3] * pow(depth, 1),
	]

# /!\ Resets the ground !
func earthquake(_intensity: float=-1) -> void:
	# print("tilemap earthquake")
	var before: int = Time.get_ticks_msec()

	var stone_variations_coords: Array[Vector2i] = [Vector2i(7, 5), Vector2i(5, 6), Vector2i(6, 6), Vector2i(7, 6)]
	var stone_variations_probabilities: Array[float] = []

	var tileset: TileSet = get_tile_set()
	# print("tileset :", tileset)
	var source: TileSetAtlasSource = tileset.get_source(1)

	for stone_variation in stone_variations_coords:
		var data: TileData = source.get_tile_data(stone_variation, 0)
		stone_variations_probabilities.push_back(data.probability)

	for y in range(ground_boundaries.position.y, ground_boundaries.end.y):
		for x in range(ground_boundaries.position.x, ground_boundaries.end.x):
			if y == ground_boundaries.position.y:
				continue
			# adjust probabilites with depth
			var adjusted_probabilities: Array[float] = adjust_probabilites(
					stone_variations_probabilities,
					y - ground_boundaries.position.y
			)
			var chosen_cell = Utils.random_with_weights(stone_variations_coords, adjusted_probabilities)
			set_cell(Vector2i(x, y), 1, chosen_cell)

	set_pattern(ground_boundaries.position, crust_pattern)

	# set_cell(Vector2i(x, y), 1, Vector2i(7, 5))
	# set_cells_terrain_connect(to_replace_with_stone, 0, 1)
	var after: int = Time.get_ticks_msec()
	print("earthquake done in %s ms" % (after - before))
	pass
