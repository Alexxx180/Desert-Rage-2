extends Node

var search: Node

const LOCKER_DEFAULT_TILE: Vector2i = Vector2i(2, 4)
const SOURCE: int = 0

func find_cell(pos: Vector2) -> Vector2i:
	return search.border.from_pos(pos).context.coords

func has_trigger(map_coords: Vector2i) -> bool:
	var has: bool = search.storage.has_trigger(map_coords)
	if not has: search.border.select(Transitions.MISSING).paint() # assert "no trigger found"
	return has

func get_atlas(map_coords: Vector2i, tag: Vector2i) -> Dictionary:
	var tile: Dictionary = search.border.from_coords(map_coords).context.duplicate()
	tile.connector = tag #assert(tile_atlas.name != "none", "no executable connection")
	return tile

func get_mech_atlas(tags: TileDecorator, pos: Vector2) -> Dictionary:
	var tag: Vector2i = tags.from_pos(pos).context.coords
	return { "connector": tag, "coords": tag }

func smart_erase(mech: Dictionary, config: Dictionary) -> void:
	mech.atlas = config.tile if config.erase else LOCKER_DEFAULT_TILE
	mech.id = config.id if config.erase else SOURCE
	search.border.paint(mech)
	config.erase = !config.erase

func set_tile(mech: Dictionary, o: Vector2i) -> void:
	mech.atlas[o.y] += o.x if mech.atlas[o.y] % 2 == 0 else -o.x
	search.border.paint(mech)

func check_tile(mech: Dictionary) -> void:
	if not mech.has("eraser"): set_tile(mech, mech.offset)
	else: smart_erase(mech, mech.eraser)

func set_mechs(tag: Vector2i) -> void: # print("LOG: ", sactivatorearch.storage.logic.connector) # print("TAG: ", tag)
	for tile in search.storage.logic.connector[tag]:
		var mech: Dictionary = search.storage.logic.machine[tile]
		match mech.type:
			"tile": check_tile(mech)
			"mech": mech.processor.toggle_logic()
