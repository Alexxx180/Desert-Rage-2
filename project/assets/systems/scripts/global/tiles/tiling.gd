extends RefCounted

class_name Tiling

static func atlas(logic: TileMapLayer, pos: Vector2) -> Dictionary:
	var coords: Vector2i = logic.local_to_map(pos)
	var id: int = logic.get_cell_source_id(coords)
	assert(id != -1, "Activator is not connected to logic")
	#print("LAYER: ", logic.name)
	#print("ID: ", id)
	return {
		"cell": logic.get_cell_atlas_coords(coords),
		"name": logic.tile_set.get_source(id).resource_name
	}

static func level(tile: Vector2) -> Dictionary:
	return { "pos": tile, "data": "P", "none": 0 }

static func floor(tile: Vector2) -> Dictionary:
	return { "pos": tile, "data": "F", "none": 0 }

static func extract(map: TileMapLayer, options: Dictionary) -> Variant:
	var cell: Vector2i = map.local_to_map(options.pos)
	var tile: TileData = map.get_cell_tile_data(cell)

	if tile == null: return options["none"]

	return tile.get_custom_data(options.data)
