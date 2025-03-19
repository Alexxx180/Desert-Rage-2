extends Node

var location: Node

func switch(pos: Vector2, appendix: int) -> void:
	var map_coords: Vector2i = location.search.find_cell(pos)
	if map_coords != Lockers.EMPTY and check_weight(map_coords, appendix):
		location.activate(map_coords)

func check_weight(map_coords: Vector2i, appendix: int) -> bool:
	var trigger: Dictionary = location.locks.trigger[map_coords]
	trigger.count += appendix
	return trigger.count == clamp(appendix, 0, 1)

func deactivate(pos: Vector2) -> void: switch(pos, -1)

func activate(pos: Vector2) -> void: switch(pos, 1)
