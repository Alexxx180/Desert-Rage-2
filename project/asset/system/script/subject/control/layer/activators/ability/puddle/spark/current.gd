extends Node

signal current_flow(map_coords: Vector2i)

var current: Array[Array] = [] # Vector2i
var size: Array[int] = []

enum { A = -2, B = -1, LENGTH = 10 }

func fire_drain(map_coords: Vector2i) -> void:
	var search: bool = true
	var direction: Vector2i
	var i: int = current.size()
	var j: int
	while i > 0 and search:
		i -= 1
		var path: Array[Vector2i] = current[i]
		j = path.size()
		while j > 2 and search:
			j -= 1
			var delta: Vector2 = Vector2(path[j] - map_coords)
			direction = delta.normalized()
			search = not is_near(direction)

	if not search:
		var k: int = current[i].size()
		while k > j:
			current[i].remove_at(k)
		current[i][j] += direction * -1

		var track: Rect2 = get_track(current[i])
		if track.size == Vector2.ZERO:
			current_flow.emit(track.position)


func at_edge(previous: Rect2i, map_coords: Vector2i) -> bool:
	return map_coords + previous.size == previous.position

func initiate_source(map_coords: Vector2i) -> void:
	current.append([map_coords, map_coords])
	size.append(LENGTH)

func is_near(direction: Vector2i) -> bool:
	return direction.x == 0 or direction.y == 0

func search_path(map_coords: Vector2i) -> int:
	var i: int = current.size() - 1
	while i >= 0 and is_near(map_coords - current[i][B]): i -= 1
	return i

func get_track(path: Array[Vector2i]) -> Rect2:
	return Rect2(path[B], Vector2(path[B] - path[A]))

func connection(map_coords: Vector2i) -> void:
	var i: int = search_path(map_coords)
	var track: Rect2 = get_track(current[i])

	if track.size == Vector2.ZERO:
		current[i][B] = map_coords
	elif at_edge(track, map_coords):
		current[i][B] += track.size#.normalized()
	else:
		current[i].append(map_coords)

	current_flow.emit(map_coords)
