extends Node

var tiles: Node

func activate(pos: Vector2) -> void:
	var map_coords: Vector2i = tiles.link.find_cell(pos)
	if map_coords != Vector2i(-1, -1):
		tiles.activate(map_coords)
