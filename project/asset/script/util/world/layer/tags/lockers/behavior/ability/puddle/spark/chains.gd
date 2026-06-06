class_name FlowConductor extends RefCounted

enum { CHAIN = 0, JOINT = 1, A = -2, B = -1, LENGTH = 10, NONE = -1, PUDDLE = 0, SOURCE = 1 }

var context: Dictionary
var current: Array[PackedInt32Array] = [] # Vector2i
var size: PackedByteArray = []
var rain: Node2D = null

func initiate_source(coords: int) -> void:
	current.append([coords, coords])
	size.append(LENGTH)
	draw_tile(coords, SOURCE)
	contact(coords)

func setup() -> void:
	for map_coords in HUD.level.border.busy(Def.SOURCE_ON, Def.LOGIC):
		initiate_source(Def.ofmap(map_coords))

func activate_puddle(pos: Vector2) -> void:
	if not _around(Def.ofmap(pos)): return
	
	if HUD.level.border.tile[Def.TYPE] == Def.PUDDLE_OFF:
		pass  # ability.spark.lazy_sparking(HUD.level.border.tcoords) TODO FIXME
	else:
		contact(HUD.level.border.tile[Def.COORDS])

func draw_the_puddle() -> void:
	if rain == null:
		rain = Def.rain.instantiate()
		HUD.level.border.add_child(rain)
	HUD.level.border.add_chip(rain)
	rain.shows()

func draw_tile(map_coords: int, no: int) -> void:
	HUD.level.border.coords(map_coords).id().atlas().type()
	match no:
		SOURCE: HUD.level.border.atlas(Def.SOURCE_ON).paint()
		PUDDLE: HUD.level.border.type(Def.PUDDLE_ON).paint_alt()

func _around(tile: int) -> bool:
	var t: PackedInt32Array = HUD.level.border.coords(tile).id().alt().tile
	return ((t[Def.ID] == Def.LOGIC and t[Def.ATLAS] == Def.SOURCE_OFF) or
		(t[Def.ID] == Def.FLOOR and t[Def.ATLAS] != Def.WALL and t[Def.TYPE] == Def.PUDDLE_OFF))

func contact(map_coords: int) -> void:
	if not (_around(map_coords + Def.yofmap(1)) or _around(map_coords + 1) or
		_around(map_coords - Def.yofmap(1)) or _around(map_coords - 1)): return
	
	map_coords = HUD.level.border.tile[Def.COORDS]
	if HUD.level.border.tile[Def.TYPE] == Def.PUDDLE_OFF:
		charge_unit(map_coords)
		return
	
	initiate_source(map_coords)
	if conduct(map_coords, current.size() - 1):
		draw_tile(map_coords, SOURCE)
		contact(map_coords)

func conduct(map_coords: int, chain: int) -> bool:
	if size[chain] == 0: return false
	var delta: int = current[chain][B] - current[chain][A]
	if delta == 0:
		current[chain][B] = map_coords
	elif map_coords - current[chain][B] == delta:
		current[chain][B] += delta
	elif map_coords != current[chain][B]:
		current[chain].append(map_coords)
	else:
		return false
	size[chain] -= 1
	return true

func at_dimension(a: Vector2i, b: Vector2i, map_coords: Vector2i, axis: int) -> bool:
	if not map_coords[axis] == b[axis]: return false
	var back: int = axis ^ 1
	var x: int = map_coords[back]
	return (a[back] <= x and x <= b[back]) or (a[back] >= x and x >= b[back])

func get_site_to_discharge(map_coords: Vector2i) -> Vector2i:
	var tile: Vector2i = Vector2i(current.size(), 0)
	for c in range(tile[CHAIN], 0, -1):
		tile[CHAIN] = c
		for j in range(current[c].size(), 1, -1):
			tile[JOINT] = j
			var a: Vector2i = Def.tomap(current[c][j - 1])
			var b: Vector2i = Def.tomap(current[c][j])
			if not (at_dimension(a, b, map_coords, Vector2.AXIS_Y) or
				at_dimension(a, b, map_coords, Vector2.AXIS_X)):
				return tile
	return tile

func charge_unit(map_coords: int) -> void:
	for chain in range(current.size(), 0, -1):
		var delta: int = map_coords - current[chain][B]
		if ((Def.xmap(delta) ^ Def.ymap(delta)) & 1 == 1) and conduct(map_coords, chain):
			draw_tile(map_coords, PUDDLE)
			contact(map_coords)
			return

func get_direction(a: int, b: int) -> int:
	return clampi(Def.ymap(a) - Def.ymap(b), -1, 1) | clampi(Def.xmap(a) - Def.xmap(b), -1, 1)

func discharge_unit(map_coords: int) -> void:
	var site: Vector2i = get_site_to_discharge(Def.tomap(map_coords))
	if site[CHAIN] == 0: return
	
	var direction: int = get_direction(map_coords, current[site[CHAIN]][site[JOINT] - 1])
	while current[site[CHAIN]].size() - 1 > site[JOINT]:
		discharge(current[site[CHAIN]][A], site[CHAIN])
		shrink_chain(site[CHAIN])
	discharge(map_coords, site[CHAIN])
	_turn_points(Vector2i(map_coords, map_coords - direction), site[CHAIN])

func discharge(target: int, chain: int) -> void: # var track: Rect2i = get_track(chain)
	var position: int = current[chain][B]
	var direction: int = get_direction(current[chain][B], current[chain][A])
	HUD.level.border.coords(position).id().alt().atlas().type(Def.PUDDLE_OFF)
	while position != target and size[chain] < 1000:
		size[chain] += 1
		HUD.level.border.coords(position).paint_alt()
		position -= direction

func shrink_chain(chain: int) -> void:
	current[chain].remove_at(current[chain].size() - 1)

func _turn_points(coords: Vector2i, chain: int) -> void:
	if current[chain].size() == 2: # source
		current[chain][B] = coords.y
	elif coords.x == current[chain][A]: # map_coords
		shrink_chain(chain)
		current[chain][B] -= get_direction(current[chain][B], current[chain][A])
	else:
		if coords.y == current[chain][A]: shrink_chain(chain)
		current[chain][B] = coords.y # target_coords
	size[chain] += 1
	contact(current[chain][B])
