class_name Block
extends RefCounted

enum Type {
	NORMAL,
	BEDROCK,
}

var x: int
var y: int
var toughness: float

var position: Vector2i:
	get: return Vector2i(x, y)

func _init(_x: int, _y: int, _toughness: float):
	x = _x
	y = _y
	toughness = _toughness

func _to_string() -> String:
	return "Block(%s,%s,%s)" % [x, y, toughness]

func equals(block: Block) -> bool:
	if block == null:
		return false
	return x == block.x and y == block.y and is_equal_approx(toughness, block.toughness)

func operator():
	pass
