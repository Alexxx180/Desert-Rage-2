extends Node

class_name Tiler

enum FLOOR { LAYER = 1, TILES = 64 }

static func get_floor(tile: TileData) -> int:
	return 0 if tile == null else tile.get_custom_data("F")

static func get_tile(map: TileMap, contact: Vector2) -> int:
	var cell: Vector2i = map.local_to_map(contact)
	var tile: TileData = map.get_cell_tile_data(FLOOR.LAYER, cell)
	return get_floor(tile)

func find_tile(map: TileMap, tracking: Node) -> int:
	var contact: Vector2 = tracking.contact

	for axis in [Vector2.AXIS_X, Vector2.AXIS_Y]:
		if fmod(contact[axis], FLOOR.TILES) == 0:
			contact[axis] += tracking.direction[axis] * 0.1

	return Tiler.get_tile(map, contact)
