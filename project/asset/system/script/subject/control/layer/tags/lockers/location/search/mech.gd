extends Node

var search: Node

const LOCKER_DEFAULT_TILE: Vector2i = Vector2i(2, 4)
const SOURCE: int = 0

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
