extends Node

var _next: bool = false

func next_level_transition(_path: String, _diff: int) -> void:
	_next = true

func available(level: Dictionary) -> Dictionary:
	if _next: return {}
	var link: Dictionary = Tile.from_pos(level.tags, level.pos)

	if !(link.name in ["none", "transition"]): return {}
	var passage: Dictionary = Tile.from_pos(level.execute, level.pos)
	
	return { "link": link, "passage": passage }
