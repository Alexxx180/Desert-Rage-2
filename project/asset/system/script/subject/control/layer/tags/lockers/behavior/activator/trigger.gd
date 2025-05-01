extends Node

var location: Node

func activate(pos: Vector2) -> void:
	map_check(location.search.find_cell(pos))

func map_check(map_coords: Vector2i) -> void:
	if map_coords != Lockers.EMPTY:
		map_activate(map_coords)

func map_activate(map_coords: Vector2i) -> void:
	location.activate(map_coords)
