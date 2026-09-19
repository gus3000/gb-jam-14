class_name Block
extends RefCounted

const TerrainType := DiggableTileMap.TerrainType

const TOUGHNESS_PER_DEPTH_UNIT: int = 500
const STARTING_LAYER: int = 8

var x: int
var y: int
var type: TerrainType
var toughness: int

var position: Vector2i:
	get: return Vector2i(x, y)

func _init(_x: int, _y: int, terrain_type: TerrainType):
	x = _x
	y = _y
	type = terrain_type
	match terrain_type:
		TerrainType.FANCY_STONE, TerrainType.STONE:
			toughness = (y - STARTING_LAYER + 1) * TOUGHNESS_PER_DEPTH_UNIT
			# toughness = log(y - STARTING_LAYER + 1) * TOUGHNESS_PER_DEPTH_UNIT
		_:
			toughness = 10000000
	toughness = max(toughness, 1)

func _to_string() -> String:
	return "Block(%s,%s,%s)" % [x, y, toughness]

func equals(block: Block) -> bool:
	if block == null:
		return false
	return x == block.x and y == block.y and toughness == block.toughness

func operator():
	pass
