extends Node

var search: Node

func find_cell(pos: Vector2) -> Vector2i:
	var map_coords: Vector2i = search.border.from_pos(pos).context.coords
	if not search.storage.has_trigger(map_coords):
		search.border.select(Transitions.MISSING).paint() # assert "no trigger found"
	return map_coords

func get_atlas(map_coords: Vector2i, tag: Vector2i) -> Dictionary:
	var tile: Dictionary = search.border.from_coords(map_coords).context.duplicate()
	tile.connector = tag #assert(tile_atlas.name != "none", "no executable connection")
	return tile

func get_mech_atlas(tags: TileDecorator, pos: Vector2) -> Dictionary:
	var tag: Vector2i = tags.from_pos(pos).context.coords
	return { "connector": tag, "coords": tag }
