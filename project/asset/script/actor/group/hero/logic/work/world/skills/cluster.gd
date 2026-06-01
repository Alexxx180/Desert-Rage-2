class_name TileCluster extends RefCounted

enum { BUTTON, LEVER, SOURCE, TELEPORT, SIZE = 16, CLUSTER = 64 }

var cluster: PackedInt32Array = []
var access: PackedInt32Array = []
var sizes: PackedByteArray = [0, 0, 0, 0]
var buttons: Dictionary[int, int] = {}
var completed: int

func resize_clusters() -> void:
	var button: PackedInt32Array = []
	var lever: PackedInt32Array = []
	var source: PackedInt32Array = []
	var teleport: PackedInt32Array = []
	
	cluster.resize(CLUSTER)
	var count: int = 0
	for y in range(0, Def.TILESET8):
		var tiles: Array[Vector2i] = HUD.level.execute.get_used_cells_by_id(Def.TAGS, Def.to8(y))
		if tiles.size() == 0: break
		if count + tiles.size() > cluster.size(): cluster.resize(cluster.size() * 2)
		
		var search: bool = true
		for x in range(0, tiles.size()):
			cluster[count + x] = Def.from256(tiles[x])
			if search:
				var tile: Dictionary = HUD.level.border.from_coords(tiles[x]).context
				match Def.from8(tile.atlas):
					Def.PLATE_OFF, Def.PLATE_ON: button.append(Def.from256(Vector2i(count, tiles.size()))) ; search = false
					Def.LEVER_OFF, Def.LEVER_ON: lever.append(Def.from256(Vector2i(count, tiles.size()))) ; search = false
					Def.SOURCE_OFF, Def.SOURCE_ON: source.append(Def.from256(Vector2i(count, tiles.size()))) ; search = false
					Def.TELEPORT_ON, Def.PLACE: teleport.append(Def.from256(Vector2i(count, tiles.size()))) ; search = false
		count += tiles.size()
	var types: Array[PackedInt32Array] = [button, lever, source, teleport]
	for i in range(0, len(types)):
		access.append_array(types[i])
		sizes[i] = types[i].size()

func button_press(no: int, add: int, compare: int, tag: int) -> void:
	var coords: int = cluster[no]
	if buttons.has(coords):
		buttons[coords] = buttons[coords] + add
	else:
		buttons[coords] = compare
	if buttons[coords] == compare: executes(tag)

func toggle_openning(no: int, on: bool) -> void:
	var tag: int = Def.from8(HUD.level.border.tile(cluster[no]))
	match tag:
		Def.PLATE_OFF: executes(Def.PLATE_ON)
		Def.PLATE_ON: executes(Def.PLATE_OFF)
		Def.U_WALL_OFF: executes(Def.U_WALL_ON if on else tag)
		Def.U_WALL_ON: executes(Def.U_WALL_OFF if on else tag)
		Def.D_WALL_OFF: executes(Def.D_WALL_ON if on else tag)
		Def.D_WALL_ON: executes(Def.D_WALL_OFF if on else tag)
		Def.STAND_OFF: button_press(no, 1, 1, Def.STAND_ON if on else tag)
		Def.STAND_ON: button_press(no, -1, 0, Def.STAND_OFF if on else tag)

func executes(next: int) -> void: HUD.level.border.switch(Def.to8(next))
func next_cluster(cursor: Vector2, count: int) -> Vector2: return Vector2(cursor.x + count, cursor.y + 1)

func switch_cluster(section: int) -> void:
	var c: int = get_cluster(section, Def.from256(HUD.level.border.context.coords))
	var z: Vector2i = Def.to256(access[c])
	var state: bool = !Bit.of(completed, c)
	completed = Bit.to(completed, c, state)
	for i in range(z.x, z.y): toggle_openning(i, state)

func get_cluster(section: int, coords: int) -> int:
	var from: int = 0
	for x in range(0, section): from += sizes[x]
	for y in range(from, from + sizes[section]):
		var z: Vector2i = Def.to256(access[y])
		for i in range(z.x, z.y): if coords == cluster[i]: return y
	return -1

func tile_press(pos: Vector2) -> void:
	match Def.from8(HUD.level.border.tpos(pos)):
		Def.PLATE_OFF: switch_cluster(BUTTON)
		Def.PLATE_ON: switch_cluster(BUTTON)

func tile_act(pos: Vector2) -> void:
	match Def.from8(HUD.level.border.tpos(pos)):
		Def.LEVER_OFF: switch_cluster(LEVER)
		Def.LEVER_ON: switch_cluster(LEVER)

func tile_spark(pos: Vector2) -> void:
	match Def.from8(HUD.level.border.tpos(pos)):
		Def.SOURCE_OFF: switch_cluster(SOURCE)
		Def.SOURCE_ON: switch_cluster(SOURCE)

func tile_walk(hero: CharacterBody2D) -> void:
	var atlas: int = Def.from8(HUD.level.border.tpos(hero.position))
	
	if atlas == Def.TELEPORT_ON:
		var c: int = get_cluster(TELEPORT, Def.from256(HUD.level.border.context.coords))
		var z: Vector2i = Def.to256(access[c])
		for i in range(z.x, z.y):
			var coords: Vector2i = Def.to8(cluster[i])
			if HUD.level.border.from_coords(coords).context.atlas == Def.PLACE:
				hero.teleport(HUD.level.border.map_to_local(coords))
				break
		return
	tile_press(hero.position)
