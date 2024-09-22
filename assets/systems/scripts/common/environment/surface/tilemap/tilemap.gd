extends Node

class_name Tiler

const FLOOR_LAYER = 1

@onready var margin: Node = $margin

static func get_floor(tile: TileData) -> int:
	return 0 if tile == null else tile.get_custom_data("F")

static func get_tile(map: TileMap, contact: Vector2) -> int:
	var cell: Vector2i = map.local_to_map(contact)
	var tile: TileData = map.get_cell_tile_data(FLOOR_LAYER, cell)
	return get_floor(tile)

func find_tile(map: TileMap, tracking: Node) -> int:
	var direction: Vector2i = tracking.direction
	var contact: Vector2 = tracking.contact
	return Tiler.get_tile(map, margin.correct(contact, direction))
