extends Node

var search: Node

func find_cell(pos: Vector2) -> Vector2i:
	var map_coords: Vector2i = Tile.from_pos(search.execute, pos).coords
	assert(search.storage.has_trigger(map_coords), "no trigger found")
	return map_coords

func get_atlas(map_coords: Vector2i, tag: Vector2i) -> Dictionary:
	var tile_atlas: Dictionary = Tile.from_coords(search.execute, map_coords)
	tile_atlas.connector = tag
	#assert(tile_atlas.name != "none", "no executable connection")
	return tile_atlas

func get_mech_atlas(tags: TileMapLayer, pos: Vector2) -> Dictionary:
	var tag: Vector2i = Tile.from_pos(tags, pos).coords
	return { "connector": tag, "coords": tag }
