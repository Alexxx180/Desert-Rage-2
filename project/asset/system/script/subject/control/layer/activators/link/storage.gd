extends Node

var active_trigger: Callable
var _execute: TileMapLayer
var locks: Dictionary = { "trigger": {}, "machine": {}, "connector": {} }

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

func setup_plate(tile: Dictionary) -> void:
	locks.trigger[tile.coords] = tile
	locks.trigger[tile.coords].count = tile.atlas.x

func setup_trigger(tile: Dictionary) -> void:
	locks.trigger[tile.coords] = tile

func setup_lock(tile: Dictionary) -> void:
	locks.machine[tile.coords] = tile
