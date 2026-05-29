class_name TileCluster extends RefCounted

enum { LEVER, BUTTON, SOURCE, TILE }

var progress: PackedByteArray
var cluster: PackedVector2Array
var teleport: Dictionary[Vector2i, PackedVector2Array]
var button: Dictionary[Vector2i, int] = {}

var completed: PackedByteArray
var execute: PackedByteArray = [Def.LEVER_OFF, Def.LEVER_ON, Def.PLATE_OFF, Def.PLATE_ON, Def.SOURCE_OFF, Def.SOURCE_ON]
var transport: PackedByteArray = [Def.U_WALL_OFF, Def.D_WALL_OFF, Def.U_WALL_ON, Def.D_WALL_ON, Def.STAND_OFF, Def.STAND_ON]

func set_types(tags: Dictionary[String, PackedVector2Array]) -> void:
	progress.resize(tags.lever.size() + tags.button.size() + tags.source.size() + TILE)
	progress[LEVER] = tags.lever.size()
	progress[BUTTON] = tags.button.size()
	progress[SOURCE] = tags.source.size()

func set_teleport(border: TileDecorator, tags: PackedVector2Array) -> void:
	for i in range(0, len(tags)):
		if Def.from8(border.tile(tags[i])) == Def.PLACE:
			teleport[Vector2i(tags[i])] = tags
			tags.remove_at(i)
			break

func _in(of: int, context: Dictionary, tiles: PackedByteArray) -> bool:
	return context.id == of and context.atlas in tiles

func set_tile(context: Dictionary, cursor: Vector2i) -> void: # var id: int = context.id # var atlas: Vector2i = border.tile(coords)
	if _in(Def.EXECUTE, context, execute):
		if context.atlas in [Def.STAND_OFF, Def.STAND_ON]:
			button[context.coords] = 0
		progress[cursor.x] = context.coords
	elif _in(Def.TRANSITION, context, transport):
		progress[cursor.x + cursor.y] = context.coords

func resize_cluster(tag: int) -> bool:
	var tiles: Array[Vector2i] = HUD.level.execute.get_used_cells_by_id(Def.LOGIC, Def.to8(tag))
	var count: int = tiles.size()
	if count == 0: return false
	
	var cursor: Vector2i = Vector2i.ZERO
	for x in progress: cursor.x += x
	progress.append(count)
	cluster.resize(cursor.x + count)
	for tile in tiles:
		set_tile(root.border.from_coords(tile).context, cursor)
		cursor.y += 1
	return true

func executes(next: int, type: int) -> void:
	HUD.level.border.switch(Def.to8(next))
	switch_cluster(type)

func transports(next: int) -> void: HUD.level.border.switch(Def.to4(next))

func button_press(no: int, add: int, compare: int) -> bool:
	var coords: Vector2i = cluster[no]
	button[coords] = button[coords] + add
	return button[coords] == compare

func toggle_openning(no: int, on: bool) -> void:
	var tag: int = Def.from8(HUD.level.border.tile(cluster[no]))
	match tag:
		Def.U_WALL_OFF: transports(Def.U_WALL_ON if on else tag)
		Def.U_WALL_ON: transports(Def.U_WALL_OFF if on else tag)
		Def.D_WALL_OFF: transports(Def.D_WALL_ON if on else tag)
		Def.D_WALL_ON: transports(Def.D_WALL_OFF if on else tag)
		Def.STAND_OFF: if button_press(no, 1, 1): transports(Def.STAND_ON if on else tag)
		Def.STAND_ON: if button_press(no, -1, 0): transports(Def.STAND_OFF if on else tag)

func toggle_tiles(bit: Vector2i, x: int, count: int) -> void:
	for i in range(x + 1, x + count):
		toggle_openning(i, Bit.of(completed[bit.x], bit.y))

func switch_tiles(cursor: Vector2i, count: int) -> void:
	var bit: Vector2i = Bit.index8(cursor.y)
	completed[bit.x] = Bit.turn(completed[bit.x], bit.y)
	toggle_tiles(bit, cursor.x, count)

func next_cluster(cursor: Vector2, count: int) -> Vector2:
	return Vector2(cursor.x + count, cursor.y + 1)

func switch_cluster(section: int) -> void:
	var x: int = TILE
	for i in range(0, section): x += progress[i]
		
	var cursor: Vector2i = Vector2i.ZERO
	for i in range(x, x + progress[section]):
		if Vector2i(cluster[cursor.x]) == HUD.level.border.tcoords:
			switch_tiles(next_cluster(cursor, progress[i]), progress[i])
			break
		cursor = next_cluster(cursor, progress[i])

func teleporting(hero: CharacterBody2D) -> bool:
	if Def.from8(HUD.level.border.tpos(hero.position)) != Def.TELEPORT_ON: return false
	for i in teleport:
		if HUD.level.border.context.coords in teleport[i]:
			hero.teleport(HUD.level.border.map_to_local(i))
			return true
	return false

func tile_press(pos: Vector2) -> bool:
	match Def.from8(HUD.level.border.tpos(pos)):
		Def.PLATE_OFF: executes(Def.PLATE_ON, BUTTON)
		Def.PLATE_ON: executes(Def.PLATE_OFF, BUTTON)
		_: return false
	return true

func tile_act(pos: Vector2, border: TileDecorator) -> void:
	match Def.from8(HUD.level.border.tpos(pos)):
		Def.LEVER_OFF: executes(Def.LEVER_ON, LEVER)
		Def.LEVER_ON: executes(Def.LEVER_OFF, LEVER)

func tile_spark(pos: Vector2, border: TileDecorator) -> void:
	match Def.from8(HUD.level.border.tpos(pos)):
		Def.SOURCE_OFF: executes(Def.SOURCE_ON, SOURCE)
		Def.SOURCE_ON: executes(Def.SOURCE_OFF, SOURCE)
	# _acting(hero, border, [Def.SOURCE_OFF, Def.SOURCE_ON])

func tile_walk(hero: CharacterBody2D) -> void:
	if teleporting(hero, border): return
	if not tile_press(hero.position, border):
		pass
