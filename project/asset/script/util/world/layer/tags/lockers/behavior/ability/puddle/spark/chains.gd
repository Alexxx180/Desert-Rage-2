class_name FlowConductor extends RefCounted

enum { A = -2, B = -1, LENGTH = 10, NONE = -1, SPARK = 0, SOURCE = 1 }

var context: Dictionary
var current: Array[PackedInt32Array] = [] # Vector2i
var size: PackedByteArray = []

func initiate_source(map_coords: Vector2i) -> void:
	var source: int = Def.from256(map_coords)
	current.append([source, source])
	size.append(LENGTH)
	draw_source(map_coords, "ON")
	contact(map_coords)

func get_track(chain: int) -> Rect2i:
	return Rect2i(current[chain][B], get_direction(current[chain][B] - current[chain][A]))

func setup() -> void:
	for map_coords in HUD.level.border.busy(Def.SOURCE_ON, Def.LOGIC):
		initiate_source(map_coords)

func activate_puddle(pos: Vector2) -> void:
	match HUD.level.border.from_pos(pos).tatlas:
		Def.SOURCE_OFF: contact(HUD.level.border.tcoords)
		TILE.OFF.PUDDLE: ability.spark.lazy_sparking(HUD.level.border.tcoords)

func draw_source(map_coords: Vector2i, status: String) -> void:
	root.border.target(map_coords).select(TILE[status].SOURCE, TILE.ID.SOURCE).paint()

func draw_puddle(map_coords: Vector2i, status: String) -> void:
	root.execute.target(map_coords).select(TILE[status].PUDDLE, TILE.ID.PUDDLE).paint()

func rain_particle(rain: Node2D) -> void:
	root.execute.add_chip(rain, "..").select(Def.PUDDLE_OFF, TILE.ID.PUDDLE).paint()

func set_puddle(cell: Vector2i, status: String) -> void:
	root.execute.select(TILE[status].PUDDLE, TILE.ID.PUDDLE).target(cell).paint()

func tile_around(tile: Vector2i) -> bool:
	var atlas: Vector2i = HUD.level.border.tatlas(tile)
	return atlas == Def.SOURCE_OFF or atlas == Def.PUDDLE_OFF # change to in later

func diffuse_puddle(cell: Vector2i, context: Dictionary) -> bool:
	if HUD.level.atlas("execute", cell) == Def.PUDDLE_ON:
		context.charge = true
	elif HUD.level.atlas("border", cell) == Def.SOURCE_ON:
		context.charge = true
	return not context.charge

func at_dimension(tiles: Dictionary, site: Array, axis: int, opposite: int) -> bool:
	if not tiles.map_coords[axis] == site[tiles.joint][axis]: return false
	var x: int = tiles.map_coords[opposite]
	var a: int = site[tiles.joint - 1][opposite]
	var b: int = site[tiles.joint][opposite]
	return (a <= x and x <= b) or (a >= x and x >= b)

func between(tiles: Dictionary, site: Array) -> bool:
	var confirm: bool = false
	var axis: int = Vector2.AXIS_Y
	while axis >= Vector2.AXIS_X and not confirm:
		var opposite_axis: int = abs(axis - 1)
		confirm = at_dimension(tiles, site, axis, opposite_axis)
		axis -= 1
	return confirm

func get_direction(delta: Vector2i) -> Vector2i:
	for axis in [Vector2.AXIS_X, Vector2.AXIS_Y]:
		if delta[axis] != 0: delta[axis] /= abs(delta[axis])
	return delta

func is_near(map_coords: Vector2i, chain: int) -> bool:
	var direction: Vector2i = map_coords - current[chain][B]
	return abs(direction.x + direction.y) == 1

func get_a_chain(map_coords: Vector2i) -> int:
	var far: bool = true
	var chain: int = current.size()
	while chain > 0 and far:
		chain -= 1
		far = not is_near(map_coords, chain)
	if far: chain = -1
	return chain

func contact(map_coords: Vector2i) -> void:
	if not (tile_around(map_coords + Vector2i(0, 1)) or
		tile_around(map_coords + Vector2i(1, 0)) or
		tile_around(map_coords + Vector2i(-1, 0)) or
		tile_around(map_coords + Vector2i(0, -1))): return
	
	map_coords = HUD.level.border.tcoords
	# puddle_charge(HUD.level.border.tcoords)
	if not not_in_spark(map_coords): return
	if HUD.level.border.atlas == Def.SOURCE_OFF:
		chains.initiate_source(map_coords)
		conduct(map_coords, current.size() - 1, conductor.draw_source)
	elif HUD.level.border.atlas == Def.PUDDLE_OFF:
		var chain: int = get_a_chain(map_coords)
		if chain == -1: return
		conduct(map_coords, chain, conductor.draw_puddle)
	else:
		push_error("invalid electricity connection number")

func conduct(chain: int, map_coords: Vector2i, draw: Callable) -> void:
	if size[chain] == 0: return
	var track: Rect2 = get_track(chain)
	if track.size == Vector2.ZERO:
		current[chain][B] = map_coords
	elif map_coords - track.position == track.size:
		current[chain][B] += track.size
	elif map_coords != current[chain][B]:
		current[chain].append(map_coords)
	else:
		return
	draw.call(map_coords, "ON")
	size[chain] -= 1
	contact(map_coords)

func discharge_unit(chains: Node, map_coords: Vector2i) -> void:
	var tiles: Dictionary = {
		"direction": Vector2i.ZERO, "map_coords": map_coords,
		"chain": chains.current.size(), "joint": 0, "search": true
	}
	while tiles.chain > 0 and tiles.search:
		tiles.chain -= 1
		tiles.joint = current[tiles.chain].size()
		while tiles.joint > 1 and tiles.search:
			tiles.joint -= 1
			var path: PackedInt32Array = current[tiles.chain]
			tiles.search = not between(tiles, path)

	tiles.search = not tiles.search
	if not tiles.search: return
		
	tiles.direction = get_direction(tiles.map_coords - current[tiles.chain][tiles.joint - 1])
	
	var chain: int = tiles.chain
	while current[chain].size() - 1 > tiles.joint:
		discharge(current[chain][A], chain)
		current[chain].pop_back()
	discharge(tiles.map_coords, chain)
	diffuse_cross_and_turn_unit(tiles.map_coords - tiles.direction, chain)

func discharge(target: Vector2i, chain: int) -> void:
	var track: Rect2i = get_track(chain)
	while track.position != target:
		size[chain] += 1
		chains.charge.draw_puddle(track.position, "OFF") # FlowConductor.TILE.PUDDLE.OFF
		track.position -= track.size

func diffuse_source_cross_turn_units(target_coords: Vector2i, chain: int) -> void:
	if current[chain].size() == 2:
		current[chain][B] = target_coords
	elif tiles.map_coords == current[chain][A]:
		current[chain].pop_back()
		current[chain][B] += -get_direction(target_coords - current[chain][A])
	else:
		if target_coords == current[chain][A]:
			current[chain].pop_back()
		current[chain][B] = target_coords
	size[chain] += 1
	chains.charge.contact(current[chain][B])
