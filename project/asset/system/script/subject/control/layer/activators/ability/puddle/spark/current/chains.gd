extends Node

enum { A = -2, B = -1, LENGTH = 10 }

var current: Array[Array] = [] # Vector2i
var size: Array[int] = []

func initiate(tiles: Array[Vector2i]) -> void:
	for map_coords in tiles: initiate_source(map_coords)

func initiate_source(map_coords: Vector2i) -> void:
	current.append([map_coords, map_coords])
	size.append(LENGTH)

func get_track(chain: int) -> Rect2i:
	var path: Array = current[chain]
	var delta: Vector2i = path[B] - path[A]
	return Rect2i(path[B], get_direction(delta))

func last_unit(chain: int) -> Vector2i:
	return current[chain][B]

func closing_unit(chain: int) -> Vector2i:
	return current[chain][A]

func last_delta(map_coords: Vector2i, chain: int) -> Vector2i:
	return map_coords - last_unit(chain)

func is_near(direction: Vector2i) -> bool:
	return ((direction.x == 0 and abs(direction.y) == 1) or
		(direction.y == 0 and abs(direction.x) == 1))

func search_path(map_coords: Vector2i) -> int:
	var far: bool = true
	var chain: int = current.size()
	while chain > 0 and far:
		chain -= 1
		far = not is_near(last_delta(map_coords, chain))
	print("IS NEAR: ", not far, " ! BUT CHAIN IS: ", chain)
	if far: chain = -1
	return chain

func get_site(chain: int, map_coords: Vector2i, unit: int = B) -> Vector2i:
	#return get_direction(current[chain][unit - 1] - map_coords)
	return get_direction(map_coords - current[chain][unit - 1])

func between(map_coords: Vector2i, chain: int, unit: int) -> bool:
	var confirm: bool = false
	var site: Array = current[chain]
	var axis: int = Vector2.AXIS_Y
	print("BETWEEN = CHAIN: ", chain, ", UNIT: ", unit, " + BUT SIZE: ", site.size())
	while axis >= Vector2.AXIS_X and not confirm:
		var i: int = abs(axis - 1)
		var x: int = map_coords[i]
		var a: int = site[unit - 1][i]
		var b: int = site[unit][i]
		confirm = (map_coords[axis] == site[unit][axis] and
			((a <= x and x <= b) or (a >= x and x >= b)))
		axis -= 1
	print("AFTER B")
	return confirm

func get_direction(delta: Vector2i) -> Vector2i:
	for axis in [Vector2.AXIS_X, Vector2.AXIS_Y]:
		if delta[axis] != 0: delta[axis] /= abs(delta[axis])
	return delta

func get_unit(chain: int, unit: int) -> Vector2i:
	return current[chain][unit]

func set_unit(chain: int, map_coords: Vector2i) -> void:
	current[chain][B] = map_coords

func add_unit(chain: int, map_coords: Vector2i) -> void:
	current[chain].append(map_coords)

func extend_chain(chain: int, map_coords: Vector2i) -> void:
	set_unit(chain, last_unit(chain) + map_coords)

func last_chain() -> int:
	return current.size() - 1

func drop_unit(chain: int) -> void:
	current[chain].pop_back()

func length(chain: int) -> int:
	return current[chain].size()
