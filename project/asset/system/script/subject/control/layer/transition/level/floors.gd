extends Node

func get_next(diff: int) -> String:
	var level: int = SessionStats.location.level.x + diff
	var path: String = "%d"
	if level > 0: path = "+/%d"
	elif level < 0: path = "-/%d"
	return path % abs(level)

func differ(layer: TileMapLayer, passage: Dictionary) -> int:
	return Tiling.custom(layer, passage.coords, Tiling.FLOOR)
