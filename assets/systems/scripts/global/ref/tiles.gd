extends RefCounted

class_name Tiles

static func get_int(map: TileMapLayer, contact: Vector2, name: String, none: int) -> int:
	var cell: Vector2i = map.local_to_map(contact)
	var tile: TileData = map.get_cell_tile_data(cell)
	return none if tile == null else tile.get_custom_data(name)
