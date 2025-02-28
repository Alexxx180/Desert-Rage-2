extends Node

var flow: Node

func evaporation(map_coords: Vector2i) -> void:
	var search: bool = true
	var direction: Vector2i
	var i: int = flow.current.size()
	var j: int
	
	while i > 0 and search:
		i -= 1
		var path: Array[Vector2i] = flow.current[i]
		j = path.size()
		while j > 2 and search:
			j -= 1
			var delta: Vector2 = Vector2(path[j] - map_coords)
			direction = delta.normalized()
			search = not flow.is_near(direction)

	if search: return
	flow.release(direction, i, j)
