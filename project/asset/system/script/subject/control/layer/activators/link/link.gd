extends Node

var active_trigger: Callable
var _execute: TileMapLayer
var storage: Node

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

func connect_tiles(locks: Dictionary, tag: Vector2i, map_coords: Array[Vector2i]) -> void:
	var i: int = map_coords.size()
	while i > 0:
		i -= 1
		var tile: Dictionary = get_atlas(map_coords[i], tag)
		match tile.atlas:
			Vector2i.ZERO, Vector2i(1, 0):
				storage.setup_plate(tile)
				map_coords.remove_at(i)
			Vector2i(0, 1), Vector2i.ONE, Vector2i(0, 3):
				storage.setup_trigger(tile)
				map_coords.remove_at(i)
			Vector2i(2, 0), Vector2i(3, 0), Vector2i(2, 2):
				storage.setup_lock(tile)
			Vector2i(3, 2), Vector2i(2, 3), Vector2i(3, 3):
				storage.setup_lock(tile)
	locks.connector[tag] = map_coords
