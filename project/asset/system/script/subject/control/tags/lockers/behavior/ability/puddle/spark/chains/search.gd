extends Node

func same_axis(tiles: Dictionary, site: Array, axis: int) -> bool:
	return tiles.map_coords[axis] == site[tiles.joint][axis]

func at_dimension(tiles: Dictionary, site: Array, axis: int) -> bool:
	var x: int = tiles.map_coords[axis]
	var a: int = site[tiles.joint - 1][axis]
	var b: int = site[tiles.joint][axis]
	return (a <= x and x <= b) or (a >= x and x >= b)

func between(tiles: Dictionary, site: Array) -> bool:
	var confirm: bool = false
	var axis: int = Vector2.AXIS_Y
	while axis >= Vector2.AXIS_X and not confirm:
		var opposite_axis: int = abs(axis - 1)
		confirm = (same_axis(tiles, site, axis) and
			at_dimension(tiles, site, opposite_axis))
		axis -= 1
	return confirm

func is_at_edge(map_coords: Vector2i, previous: Rect2i) -> bool:
	return map_coords - previous.position == previous.size

func discharged_unit(chains: Node, map_coords: Vector2i) -> Dictionary:
	var tiles: Dictionary = {
		"direction": Vector2i.ZERO, "map_coords": map_coords,
		"chain": chains.current.size(), "joint": 0, "search": true
	}
	while tiles.chain > 0 and tiles.search:
		tiles.chain -= 1
		tiles.joint = chains.length(tiles.chain)
		while tiles.joint > 1 and tiles.search:
			tiles.joint -= 1
			var path: Array = chains.get_chain(tiles.chain)
			tiles.search = not between(tiles, path)

	tiles.search = not tiles.search
	if tiles.search:
		tiles.direction = chains.get_site(tiles.chain, tiles.map_coords, tiles.joint)
	
	return tiles

func get_direction(delta: Vector2i) -> Vector2i:
	for axis in [Vector2.AXIS_X, Vector2.AXIS_Y]:
		if delta[axis] != 0: delta[axis] /= abs(delta[axis])
	return delta

func get_track(A: Vector2i, B: Vector2i) -> Rect2i:
	return Rect2i(B, get_direction(B - A))

func is_near(direction: Vector2i) -> bool:
	return ((direction.x == 0 and abs(direction.y) == 1) or
		(direction.y == 0 and abs(direction.x) == 1))

func get_chain(chains: Node, map_coords: Vector2i) -> int:
	var far: bool = true
	var chain: int = chains.current.size()
	while chain > 0 and far:
		chain -= 1
		far = not is_near(chains.last_delta(map_coords, chain))
	if far: chain = -1
	return chain
