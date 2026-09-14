class_name Block
extends RefCounted

const TerrainType := MineableTimeMap.TerrainType

enum Type {
	NORMAL,
	BEDROCK,
}

const TOUGHNESS_PER_DEPTH_UNIT: float = 100
const STARTING_LAYER: int = 8

var x: int
var y: int
var toughness: float

var position: Vector2i:
	get: return Vector2i(x, y)

func _init(_x: int, _y: int, terrain_type: TerrainType):
	x = _x
	y = _y
	match terrain_type:
		TerrainType.FANCY_STONE, TerrainType.STONE:
			toughness = (y - STARTING_LAYER + 1) * TOUGHNESS_PER_DEPTH_UNIT
		_:
			toughness = 1000000
	toughness = max(toughness, 0.1)

func _to_string() -> String:
	return "Block(%s,%s,%s)" % [x, y, toughness]

func equals(block: Block) -> bool:
	if block == null:
		return false
	return x == block.x and y == block.y and is_equal_approx(toughness, block.toughness)

func operator():
	pass
