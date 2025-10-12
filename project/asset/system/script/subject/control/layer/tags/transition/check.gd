extends Node

var _next: bool = false
var _lay: Node

func set_layers(lay: Node) -> void: _lay = lay

func next_level_transition(_path: String, _diff: int) -> void:
	_next = true

func transitable(map: Dictionary) -> bool:
	if _next: return false
	map.link = _lay.tags.from_pos(map.pos).context

	if not map.link.name in ["none", "transition"]: return false
	map.way = _lay.execute.from_pos(map.pos).context
	return true
