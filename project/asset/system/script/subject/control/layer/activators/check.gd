extends Node

var active_trigger: Callable
var _execute: TileMapLayer

func setup(execute: TileMapLayer, action: Callable) -> void:
	active_trigger = action
	_execute = execute

func find_cell_by_coords(map_coords: Vector2i) -> Vector2i:
	assert(active_trigger.call(map_coords), "no trigger found")
	return map_coords

func find_cell(pos: Vector2) -> Vector2i:
	return find_cell_by_coords(Tile.from_pos(_execute, pos).coords)

func get_atlas(map_coords: Vector2i, tag: Vector2i) -> Dictionary:
	var tile_atlas: Dictionary = Tile.from_coords(_execute, map_coords)
	tile_atlas.connector = tag
	assert(tile_atlas.name != "none", "no executable connection")
	return tile_atlas

func setup_plate(locks, tile_atlas: Dictionary, count: int) -> void:
	locks.trigger[tile_atlas.coords] = tile_atlas
	locks.trigger[tile_atlas.coords].count = count

func setup_trigger(locks, tile_atlas: Dictionary) -> void:
	locks.trigger[tile_atlas.coords] = tile_atlas

func connect_tiles(locks: Dictionary, tag: Vector2i, map_coords: Array[Vector2i]) -> void:
	var i: int = map_coords.size()
	while i > 0:
		i -= 1
		var tile_atlas: Dictionary = get_atlas(map_coords[i], tag)
		var atlas_coords: Vector2i = Tile.atlas_coords(_execute, map_coords[i])
		match atlas_coords:
			Vector2i.ZERO, Vector2i(1, 0):
				setup_plate(locks, tile_atlas, atlas_coords.x)
				map_coords.remove_at(i)
			Vector2i(0, 1), Vector2i.ONE, Vector2i(0, 3):
				setup_trigger(locks, tile_atlas)
				map_coords.remove_at(i)
			Vector2i(2, 0), Vector2i(3, 0), Vector2i(2, 2):
				locks.machine[map_coords[i]] = tile_atlas
			Vector2i(3, 2), Vector2i(2, 3), Vector2i(3, 3):
				locks.machine[map_coords[i]] = tile_atlas
	locks.connector[tag] = map_coords
