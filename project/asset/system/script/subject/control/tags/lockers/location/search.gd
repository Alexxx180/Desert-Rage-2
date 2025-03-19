extends Node

var active_trigger: Callable
var _execute: TileMapLayer

func setup(execute: TileMapLayer, action: Callable) -> void:
	active_trigger = action
	_execute = execute

func set_lock(lock: Dictionary) -> void:
	lock.atlas.x += 1 if lock.atlas.x % 2 == 0 else -1
	Tile.paint(_execute, lock)

func activate(locks: Dictionary, map_coords: Vector2i) -> void:
	var activator: Dictionary = locks.trigger[map_coords]
	set_lock(activator)
	for lock in locks.connector[activator.connector]:
		set_lock(locks.machine[lock])

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
