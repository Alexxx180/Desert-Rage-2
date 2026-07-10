class_name TileCluster extends RefCounted

enum { BUTTON, LEVER, SOURCE, TELEPORT, SIZE = 16, CLUSTER = 64 }

var cluster: PackedInt32Array = []
var access: PackedInt32Array = []
var sizes: PackedByteArray = [0, 0, 0, 0]
var buttons: Dictionary[int, int] = {}
var completed: int
var hint: PackedInt32Array = []

func help_show(pos: Vector2i) -> int:
	for i in range(0, len(hint), 2):
		if Def.tomap(hint[i]) >= pos and pos <= Def.tomap(hint[i + 1]):
			return i
	return -1

func help_hint() -> void:
	for tile in range(0, Def.T8):
		var tiles: PackedVector2Array = HUD.level.execute.get_used_cells_by_id(Def.TAGS, Def.to8(tile), Def.HELP) # Def.to8(tile)
		var i: int = 0
		match tiles.size():
			0: continue
			2: i = 1
		var a: Vector2i = tiles[0].min(tiles[i])
		var b: Vector2i = tiles[i].max(tiles[0])
		hint.append(Def.ofmap(a))
		hint.append(Def.ofmap(b))
		for tag in tiles: HUD.level.execute.erase_cell(tag)
		for y in range(a.y, b.y + 1):
			for x in range(a.x, b.x + 1):
				HUD.level.border.coords(Def.of(x, y)).type().id().atlas()
				if (HUD.level.border.tile[Def.ATLAS] == Def.GROUND and
					HUD.level.border.tile[Def.ID] in [Def.FLOOR, Def.WALLS]):
					HUD.level.border.atlas(Def.HINT).id(Def.FLOOR).paint_alt()


func reset_button_completion() -> void:
	if sizes[BUTTON] == 0: return
	
	
	
	pass

func resize_clusters() -> void:
	var button: PackedInt32Array = []
	var lever: PackedInt32Array = []
	var source: PackedInt32Array = []
	var teleport: PackedInt32Array = []
	
	cluster.resize(CLUSTER)
	var count: int = 0
	for y in range(0, Def.T8):
		var tiles: PackedVector2Array = HUD.level.execute.get_used_cells_by_id(Def.TAGS, Def.to8(y))
		if tiles.size() == 0: break
		if count + tiles.size() > cluster.size(): cluster.resize(cluster.size() * 2)
		
		var search: bool = true
		for x in range(0, tiles.size()):
			cluster[count + x] = Def.ofmap(tiles[x])
			if search:
				search = false
				match Def.of8(HUD.level.border.coords(tiles[x]).tile[Def.ATLAS]):
					Def.PLATE_OFF, Def.PLATE_ON: button.append(Def.of(tiles.size(), count))
					Def.LEVER_OFF, Def.LEVER_ON: lever.append(Def.of(tiles.size(), count))
					Def.SOURCE_OFF, Def.SOURCE_ON: source.append(Def.of(tiles.size(), count))
					Def.TELEPORT_ON, Def.PLACE: teleport.append(Def.of(tiles.size(), count))
					_: search = true
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
	for i in range(Def.x(access[c]), Def.y(access[c])):
		toggle_openning(i, state, enter)

func get_cluster(section: int, coords: int) -> int:
	var from: int = 0
	for x in range(0, section): from += sizes[x]
	for y in range(from, from + sizes[section]):
		for i in range(Def.x(access[y]), Def.y(access[y])):
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

var no: int = -1

func tile_walk(hero: CharacterBody2D, enter: bool = true) -> void:
	if not enter and no != -1:
		HUD.menu.log_help_hide()
		no = -1
	
	var atlas: int = HUD.level.border.coords(HUD.level.tile[Def.offset(hero.no, Def.PLATE)]).atlas().tile[Def.ATLAS]
	if atlas == Def.TELEPORT_ON:
		var c: int = get_cluster(TELEPORT, Def.ofmap(HUD.level.border.tile[Def.COORDS]))
		for i in range(Def.x(access[c]), Def.y(access[c])):
			if HUD.level.border.coords(cluster[i]).tile[Def.ATLAS] == Def.PLACE:
				hero.teleport(HUD.level.border.map_to_local(Def.tomap(cluster[i])))
				break
	elif atlas == Def.HINT and HUD.level.border.tile[Def.ID] == Def.FLOOR:
		no = help_show(HUD.level.border.local_to_map(hero.position))
		if no != -1: HUD.menu.log_help(no)
	else:
		tile_press(HUD.level.border.tile[Def.COORDS], enter)

func secret_reveal() -> void:
	pass
