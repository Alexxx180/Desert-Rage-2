extends Node

class_name Tiler

@onready var margin: Node = $margin

static func get_floor(floors: TileMapLayer, contact: Vector2) -> int:
	var cell: Vector2i = floors.local_to_map(contact)
	var tile: TileData = floors.get_cell_tile_data(cell)
	return 0 if tile == null else tile.get_custom_data("F")

func find_floor_tile(floors: TileMapLayer, tracking: Node) -> int:
	return Tiler.get_floor(floors, margin.correct(tracking))
