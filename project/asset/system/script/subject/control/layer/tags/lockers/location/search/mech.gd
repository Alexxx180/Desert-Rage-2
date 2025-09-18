extends Node

var search: Node
const LOCKER_DEFAULT_TILE: Vector2i = Vector2i(3, 6)

func smart_erase(mech: Dictionary, config: Dictionary) -> void:
	mech.atlas = config.tile if config.erase else LOCKER_DEFAULT_TILE
	Tile.paint(search.execute, mech)
	config.erase = !config.erase

func set_tile(mech: Dictionary) -> void:
	var x: int = mech.offset.x
	var axis: int = mech.offset.y
	mech.atlas[axis] += x if mech.atlas[axis] % 2 == 0 else -x
	Tile.paint(search.execute, mech)

func check_tile(mech: Dictionary) -> void:
	if not mech.has("eraser"): set_tile(mech)
	else: smart_erase(mech, mech.eraser)

func set_mechs(tag: Vector2i) -> void:
	# print("LOG: ", sactivatorearch.storage.logic.connector)
	# print("TAG: ", tag)
	for tile in search.storage.logic.connector[tag]:
		var mech: Dictionary = search.storage.logic.machine[tile]
		match mech.type:
			"tile": check_tile(mech)
			"mech": mech.processor.toggle_logic()
