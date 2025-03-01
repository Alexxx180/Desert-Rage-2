extends Node

var flow: Node

func evaporation(map_coords: Vector2i) -> void:
	var search: bool = true
	var direction: Vector2i
	var i: int = flow.current.size()
	var j: int
	var path: Array
	
	while i > 0 and search:
		i -= 1
		path = flow.current[i]
		j = path.size()
		while j > 2 and search:
			j -= 1
			var delta: Vector2 = Vector2(path[j] - map_coords)
			direction = delta.normalized()
			# search = not (direction.x == 0 or direction.y == 0)
			search = not flow.is_near(direction)
	if not search:
		if map_coords != path[j]: j += 1
		print("FIND: ", i, " - ", j)
		#flow.execute.erase(map_coords)
		flow.release(map_coords - direction, i, j)
