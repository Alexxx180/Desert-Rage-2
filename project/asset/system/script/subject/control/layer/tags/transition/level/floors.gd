extends Node

func assign(path: String) -> void:
	var i: int = path.find("-", 1)
	SessionStats.location.level = int(path.substr(0, i))
	SessionStats.location.part = int(path.substr(i + 1))
	SessionStats.location.save = true
	print("Session stats assign: ", SessionStats.location)

func get_next(diff: int) -> String:
	var level: int = SessionStats.location.level + diff
	var path: String = "%d"
	if level > 0: path = "+/%d"
	elif level < 0: path = "-/%d"
	return path % abs(level)

func differ(layer: TileMapLayer, passage: Dictionary) -> int:
	return Tile.extract(layer, passage.coords, Tile.FLOOR)
