extends Node

var unstable: Dictionary = {} # Vector2i, int

func by(map_coords: Vector2i, check: Callable) -> Vector2i:
	var i: int = 2
	var j: int
	var can_spark: bool = true

	while (can_spark and i > 0):
		i -= 1
		j = 3

		while (can_spark and j > -1):
			j -= 2
			var near: Vector2i = map_coords
			near[i] += j
			can_spark = check.call(near)
			# not near in unstable

	var direction: Vector2i = Vector2i.ZERO
	if can_spark:
		direction[i] += j

	return direction
