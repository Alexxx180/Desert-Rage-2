extends Node

var tiles: Node

func switch(pos: Vector2, appendix: int) -> void:
	var map_coords: Vector2i = tiles.link.find_cell(pos)
	if map_coords == Vector2i(-1, -1): return
	
	var trigger: Dictionary = tiles.locks.trigger
	trigger[map_coords].count += appendix
	if trigger[map_coords].count == clamp(appendix, 0, 1):
		tiles.activate(map_coords)

func deactivate(pos: Vector2) -> void: switch(pos, -1)

func activate(pos: Vector2) -> void: switch(pos, 1)
