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

func _in(of: int, context: Dictionary, tiles: PackedByteArray) -> bool: return context.id == of and context.atlas in tiles

func set_tile(context: Dictionary, cursor: Vector2i) -> void: # var id: int = context.id # var atlas: Vector2i = border.tile(coords)
	if _in(Def.EXECUTE, context, execute):
		if context.atlas in [Def.STAND_OFF, Def.STAND_ON]:
			button[context.coords] = 0
		progress[cursor.x] = context.coords
	elif _in(Def.TRANSITION, context, transport):
		progress[cursor.x + cursor.y] = context.coords

func resize_cluster(root: LevelRoot, tag: int) -> bool:
	var tiles: Array[Vector2i] = root.execute.layer.get_used_cells_by_id(Def.LOGIC, Def.to8(tag))
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

func has(count: int) -> bool: return count > 0
func executes(border: TileDecorator, next: int) -> void: border.switch(Def.to8(next))
func transports(border: TileDecorator, next: int) -> void: border.switch(Def.to4(next))
func atlas_of(border: TileDecorator, i: int) -> int: return Def.from8(border.tile(cluster[i]))

func _state(a: int, b: int, next: bool) -> int: return a if next else b

func button_press(coords: Vector2i, add: int, compare: int) -> bool:
	button[coords] = button[coords] + add
	return button[coords] == compare

func toggle_openning(no: int, state: bool, border: TileDecorator) -> void:
	var tag: int = Def.from8(border.tile(cluster[no]))
	match tag:
		Def.U_WALL_OFF: transports(border, _state(Def.U_WALL_ON, tag, state))
		Def.U_WALL_ON: transports(border, _state(Def.U_WALL_OFF, tag, state))
		Def.D_WALL_OFF: transports(border, _state(Def.D_WALL_ON, tag, state))
		Def.D_WALL_ON: transports(border, _state(Def.D_WALL_OFF, tag, state))
		Def.STAND_OFF:
			if button_press(cluster[no], 1, 1):
				transports(border, _state(Def.STAND_ON, tag, state))
		Def.STAND_ON:
			if button_press(cluster[no], -1, 0):
				transports(border, _state(Def.STAND_OFF, tag, state))

func toggle_tiles(bit: Vector2i, x: int, count: int, border: TileDecorator) -> void:
	for i in range(x + 1, x + count):
		toggle_openning(i, Bit.of(completed[bit.x], bit.y), border)

func switch_tiles(cursor: Vector2i, count: int, border: TileDecorator) -> void:
	var bit: Vector2i = Bit.index8(cursor.y)
	completed[bit.x] = Bit.turn(completed[bit.x], bit.y)
	toggle_tiles(bit, cursor.x, count, border)

func next_cluster(cursor: Vector2, count: int) -> Vector2: return Vector2(cursor.x + count, cursor.y + 1)

func switch_cluster(section: int, border: TileDecorator) -> void:
	var x: int = TILE
	for i in range(0, section): x += progress[i]
		
	var cursor: Vector2i = Vector2i.ZERO
	for i in range(x, x + progress[section]):
		var count: int = progress[i]
		if Vector2i(cluster[cursor.x]) != border.tcoords:
			cursor = next_cluster(cursor, count)
			continue
		switch_tiles(next_cluster(cursor, count), count, border)
		break

func teleporting(hero: CharacterBody2D, border: TileDecorator) -> bool:
	if Def.from8(border.tpos(hero.position)) != Def.TELEPORT_ON: return false
	for i in teleport:
		if border.context.coords in teleport[i]:
			hero.teleport(border.layer.map_to_local(i))
			return true
	return false

func tile_walk(hero: CharacterBody2D, border: TileDecorator) -> void:
	if teleporting(hero, border): return
	tile_press(hero.position, border)

func tile_press(pos: Vector2, border: TileDecorator) -> void:
	match Def.from8(border.tpos(pos)):
		Def.PLATE_OFF: executes(border, Def.PLATE_ON) ; switch_cluster(BUTTON, border)
		Def.PLATE_ON: executes(border, Def.PLATE_OFF) ; switch_cluster(BUTTON, border)

func tile_act(pos: Vector2, border: TileDecorator) -> void:
	match Def.from8(border.tpos(pos)):
		Def.LEVER_OFF: executes(border, Def.LEVER_ON) ; switch_cluster(LEVER, border)
		Def.LEVER_ON: executes(border, Def.LEVER_OFF) ; switch_cluster(LEVER, border)

func tile_spark(pos: Vector2, border: TileDecorator) -> void:
	match Def.from8(border.tpos(pos)):
		Def.SOURCE_OFF: executes(border, Def.SOURCE_ON) ; switch_cluster(SOURCE, border)
		Def.SOURCE_ON: executes(border, Def.SOURCE_OFF) ; switch_cluster(SOURCE, border)
	# _acting(hero, border, [Def.SOURCE_OFF, Def.SOURCE_ON])
