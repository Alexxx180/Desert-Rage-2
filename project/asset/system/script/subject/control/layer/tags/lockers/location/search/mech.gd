extends Node

var search: Node

func set_tile(static_mech: Dictionary) -> void:
	static_mech.atlas.x += 1 if static_mech.atlas.x % 2 == 0 else -1
	Tile.paint(search.execute, static_mech)

func set_mechs(tag: Vector2i) -> void:
	# print("LOG: ", search.storage.logic.connector)
	# print("TAG: ", tag)
	for tile in search.storage.logic.connector[tag]:
		var mech: Dictionary = search.storage.logic.machine[tile]
		match mech.type:
			"tile": set_tile(mech)
			"mech": mech.processor.toggle_logic()
