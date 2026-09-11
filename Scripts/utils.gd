class_name Utils

enum Direction {UP, DOWN, LEFT, RIGHT}
const RAY_LENGTH: int = 1

static func vector2_from_direction(direction: Direction) -> Vector2:
	match direction:
		Utils.Direction.UP:
			return Vector2(0, -RAY_LENGTH)
		Utils.Direction.DOWN:
			return Vector2(0, +RAY_LENGTH)
		Utils.Direction.LEFT:
			return Vector2(-RAY_LENGTH, 0)
		Utils.Direction.RIGHT:
			return Vector2(+RAY_LENGTH, 0)
	return Vector2(0, 0)

static func string_from_direction(direction: Direction)->String:
	match direction:
		Direction.UP:
			return "UP"
		Direction.DOWN:
			return "DOWN"
		Direction.LEFT:
			return "LEFT"
		Direction.RIGHT:
			return "RIGHT"
		_:
			return "UNKOWN"