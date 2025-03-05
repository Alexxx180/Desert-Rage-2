extends Node

var active_trigger: Callable
var execute: TileMapLayer

func find_cell_by_coords(map_coords: Vector2i) -> Vector2i:
	assert(active_trigger.call(map_coords), "no trigger found")
	return map_coords

func find_cell(pos: Vector2) -> Vector2i:
	return find_cell_by_coords(Tile.from_pos(execute, pos).coords)

func get_atlas(map_coords: Vector2i) -> Dictionary:
	var tile_atlas: Dictionary = Tile.from_coords(execute, map_coords)
	assert(tile_atlas.name != "none", "no executable connection")
	return tile_atlas

func connect_tiles(locks: Dictionary, tag: Vector2i, placement: Array[Vector2i]) -> void:
	var i: int = placement.size()
	while i > 0:
		i -= 1
		var map_coords: Vector2i = placement[i]
		var tile_atlas: Dictionary = get_atlas(map_coords)
		var atlas_coords: Vector2i = Tile.atlas_coords(execute, map_coords)
		match atlas_coords:
			Vector2i.ZERO, Vector2i(1, 0):
				tile_atlas.connector = tag
				locks.trigger[map_coords] = tile_atlas
				locks.trigger[map_coords].count = atlas_coords.x
				placement.remove_at(i)
			Vector2i(0, 1), Vector2i.ONE, Vector2i(0, 3):
				tile_atlas.connector = tag
				locks.trigger[map_coords] = tile_atlas
				placement.remove_at(i)
			Vector2i(2, 0), Vector2i(3, 0), Vector2i(2, 2), Vector2i(3, 2), Vector2i(2, 3), Vector2i(3, 3):
				locks.machine[map_coords] = tile_atlas
			_: pass
	locks.connector[tag] = placement
