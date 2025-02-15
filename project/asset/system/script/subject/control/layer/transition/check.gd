extends Node

var _next: bool = false
var execute: TileMapLayer
var _tags: TileMapLayer

func set_layers(_execute: TileMapLayer, tags: TileMapLayer) -> void:
	execute = _execute
	_tags = tags

func next_level_transition(_path: String, _diff: int) -> void:
	_next = true

func transitable(map: Dictionary) -> bool:
	if _next: return false
	map.link = Tile.from_pos(_tags, map.pos)

	if not map.link.name in ["none", "transition"]: return false
	map.way = Tile.from_pos(execute, map.pos)
	return true
