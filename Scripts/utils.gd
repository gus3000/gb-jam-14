class_name Utils

enum Direction {UP, DOWN, LEFT, RIGHT}
const RAY_LENGTH: int = 1

static func vector2_from_direction(direction: Direction) -> Vector2:
	match direction:
		Direction.UP:
			return Vector2(0, -RAY_LENGTH)
		Direction.DOWN:
			return Vector2(0, +RAY_LENGTH)
		Direction.LEFT:
			return Vector2(-RAY_LENGTH, 0)
		Direction.RIGHT:
			return Vector2(+RAY_LENGTH, 0)
	return Vector2(0, 0)

# use Direction.keys()[direction] instead
static func string_from_direction(direction: Direction) -> String:
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

static func random_with_weights(elements: Array, weights: Array[float]):
	var sum = weights.reduce(func(accum, number): return accum + number)
	var float_index: float = randf_range(0, sum)
	var w: float = 0
	for i in range(len(weights)):
		w += weights[i]
		if float_index <= w:
			# print(elements, " -> rand= ", float_index, " -> index ", i)
			return elements[i]
	assert(false)

static func format_int(n: int) -> String:
	var number_string := ""
	var current_digit_pos: int = 0
	while n != 0:
		if current_digit_pos > 0 and current_digit_pos % 3 == 0:
			number_string = " %s" % number_string
		number_string = "%d%s" % [n % 10, number_string]
		n /= 10
		current_digit_pos += 1
	return number_string