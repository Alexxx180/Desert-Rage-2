extends Node

class_name Tiler

@onready var margin: Node = $margin

static func get_tile(floors: TileMapLayer, contact: Vector2) -> int:
	var cell: Vector2i = floors.local_to_map(contact)
	var tile: TileData = floors.get_cell_tile_data(cell)
	return 0 if tile == null else tile.get_custom_data("F")

func find_tile(layer: TileMapLayer, tracking: Node) -> int:
	var direction: Vector2i = tracking.direction
	var contact: Vector2 = tracking.contact
	return Tiler.get_tile(layer, margin.correct(contact, direction))
