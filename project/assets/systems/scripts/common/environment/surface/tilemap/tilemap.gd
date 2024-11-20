extends Node

class_name Tiler

@onready var margin: Node = $margin

static func get_floor(floors: TileMapLayer, contact: Vector2) -> int:
	return Tiles.get_int(floors, contact, "F", 0)

func find_floor_tile(floors: TileMapLayer, tracking: Node) -> int:
	return Tiler.get_floor(floors, margin.correct(tracking))
