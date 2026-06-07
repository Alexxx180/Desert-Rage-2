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
		var tiles: PackedVector2Array = HUD.level.execute.get_used_cells_by_id(Def.TAGS, Def.to8(y))
		if tiles.size() == 0: break
		if count + tiles.size() > cluster.size(): cluster.resize(cluster.size() * 2)
		
		var search: bool = true
		for x in range(0, tiles.size()):
			cluster[count + x] = Def.ofmap(tiles[x])
			if search:
				match Def.of8(HUD.level.border.coords(tiles[x]).tile[Def.ATLAS]):
					Def.PLATE_OFF, Def.PLATE_ON: button.append(Def.ymap(tiles.size()) | count) ; search = false
					Def.LEVER_OFF, Def.LEVER_ON: lever.append(Def.ymap(tiles.size()) | count) ; search = false
					Def.SOURCE_OFF, Def.SOURCE_ON: source.append(Def.ymap(tiles.size()) | count) ; search = false
					Def.TELEPORT_ON, Def.PLACE: teleport.append(Def.ymap(tiles.size()) | count) ; search = false
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

func toggle_openning(no: int, on: bool, enter: bool) -> void:
	var tag: int = Def.of8(HUD.level.border.coords(cluster[no]).tile[Def.ATLAS])
	match tag:
		Def.PLATE_OFF: button_press(no, +1, 1, Def.PLATE_ON if on else tag)
		Def.PLATE_ON: button_press(no, +1 if enter else -1, 0, Def.PLATE_OFF if on else tag)
		Def.U_WALL_OFF: executes(Def.U_WALL_ON if on else tag)
		Def.U_WALL_ON: executes(Def.U_WALL_OFF if on else tag)
		Def.D_WALL_OFF: executes(Def.D_WALL_ON if on else tag)
		Def.D_WALL_ON: executes(Def.D_WALL_OFF if on else tag)
		Def.STAND_OFF: executes(Def.STAND_OFF if on else tag)
		Def.STAND_ON: executes(Def.STAND_ON if on else tag)

func executes(next: int) -> void: HUD.level.border.switch(Def.to8(next))
func next_cluster(cursor: Vector2, count: int) -> Vector2: return Vector2(cursor.x + count, cursor.y + 1)

func switch_cluster(section: int, enter: bool) -> void:
	var c: int = get_cluster(section, Def.ofmap(HUD.level.border.tile[Def.COORDS]))
	var state: bool = !Bit.of(completed, c)
	completed = Bit.to(completed, c, state)
	for i in range(Def.xmap(access[c]), Def.ymap(access[c])):
		toggle_openning(i, state, enter)

func get_cluster(section: int, coords: int) -> int:
	var from: int = 0
	for x in range(0, section): from += sizes[x]
	for y in range(from, from + sizes[section]):
		for i in range(Def.xmap(access[y]), Def.ymap(access[y])):
			if coords == cluster[i]: return y
	return -1

func tile_press(coords: int, enter: bool = true) -> void:
	match HUD.level.border.coords(coords).id().atlas().tile[Def.ATLAS]:
		Def.PLATE_OFF: switch_cluster(BUTTON, enter)
		Def.PLATE_ON: switch_cluster(BUTTON, enter)

func tile_act(coords: int) -> void:
	match HUD.level.border.coords(coords).id().atlas().tile[Def.ATLAS]:
		Def.LEVER_OFF: switch_cluster(LEVER, true)
		Def.LEVER_ON: switch_cluster(LEVER, true)

func tile_spark(coords: int) -> void:
	match HUD.level.border.coords(coords).id().atlas().tile[Def.ATLAS]:
		Def.SOURCE_OFF: switch_cluster(SOURCE, true)
		Def.SOURCE_ON: switch_cluster(SOURCE, true)

func tile_melt(coords: int) -> void:
	HUD.level.border.coords(coords).id().alt().type()
	if HUD.level.border.tile[Def.TYPE] == Def.ICE_FLOOR:
		HUD.level.border.type(Def.FLOOR).paint_alt()

func tile_walk(hero: CharacterBody2D, enter: bool = true) -> void:
	var atlas: int = Def.of8(HUD.level.border.coords(HUD.level.get_tile(hero.no, Def.PLATE)).tile[Def.ATLAS])
	if atlas == Def.TELEPORT_ON:
		var c: int = get_cluster(TELEPORT, Def.ofmap(HUD.level.border.tile[Def.COORDS]))
		for i in range(Def.xmap(access[c]), Def.ymap(access[c])):
			if HUD.level.border.coords(cluster[i]).tile[Def.ATLAS] == Def.PLACE:
				hero.teleport(HUD.level.border.map_to_local(Def.tomap(cluster[i])))
				break
		return
	tile_press(HUD.level.border.tile[Def.COORDS], enter)
