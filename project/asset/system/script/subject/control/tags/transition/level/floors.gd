extends Node

func assign(path: String) -> void:
	var i: int = path.find("-", 1)
	var level: int = int(path.substr(0, i))
	var part: int = int(path.substr(i + 1))
	SessionStats.location.level = Vector2i(level, part)
	print("path: ", path, ", floor: ", level, ", part: ", part)

func get_next(diff: int) -> String:
	var level: int = SessionStats.location.level.x + diff
	var path: String = "%d"
	if level > 0: path = "+/%d"
	elif level < 0: path = "-/%d"
	return path % abs(level)

func differ(layer: TileMapLayer, passage: Dictionary) -> int:
	return Tile.extract(layer, passage.coords, Tile.FLOOR)
