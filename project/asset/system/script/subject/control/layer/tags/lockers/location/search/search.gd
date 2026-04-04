class_name StorageSearch extends RefCounted

const LOCKER_DEFAULT_TILE: Vector2i = Vector2i(2, 4)

var root: LevelRoot
var storage: LockersStorage = LockersStorage.new()

func activate(map_coords: Vector2i) -> void:
	var activator: Dictionary = storage.logic.trigger[map_coords]
	var tag: Vector2i = activator.connector
	set_tile(activator, Vector2i(1, 0))
	set_mechs(tag)

func get_border_tile_coords(pos: Vector2) -> Vector2i:
	return root.border.from_pos(pos).tcoords

func has_trigger(map_coords: Vector2i) -> bool:
	var has: bool = storage.has_trigger(map_coords)
	if not has: root.border.select(Transitions.MISSING).paint() # assert "no trigger found"
	return has

func get_mech_atlas(tags: TileDecorator, pos: Vector2) -> Dictionary:
	var tag: Vector2i = tags.from_pos(pos).context.coords
	return { "connector": tag, "coords": tag }

func get_prop(config: Dictionary, prop: String, default: Variant) -> Variant:
	return config[prop] if config.erase else default

func smart_erase(mech: Dictionary, config: Dictionary) -> void:
	mech.atlas = get_prop(config, "tile", LOCKER_DEFAULT_TILE)
	mech.id = get_prop(config, "id", Lockers.MECH)
	root.border.paint(mech)
	config.erase = !config.erase

func set_tile(mech: Dictionary, o: Vector2i) -> void:
	mech.atlas[o.y] += o.x if mech.atlas[o.y] % 2 == 0 else -o.x
	root.border.paint(mech)

func check_tile(mech: Dictionary) -> void:
	if not mech.has("eraser"): set_tile(mech, mech.offset)
	else: smart_erase(mech, mech.eraser)

func set_mechs(tag: Vector2i) -> void: # print("LOG: ", sactivatorearch.storage.logic.connector) # print("TAG: ", tag)
	for tile in storage.logic.connector[tag]:
		var mech: Dictionary = storage.logic.machine[tile]
		match mech.type:
			"tile": check_tile(mech)
			"mech": mech.processor.toggle_logic()
