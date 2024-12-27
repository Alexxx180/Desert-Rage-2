extends Node

const SOURCE_ATLAS: String = "transition"

var _next: bool = false

func next_level_transition(_path: String, _diff: int) -> void:
	_next = true

func available(map: Dictionary, transition: Dictionary) -> bool:
	if _next: return false
	
	var pos: Vector2 = transition.hero.position
	map.connect = Tiling.atlas(transition.tags, pos)
	map.none = map.connect.name == "none"
	
	if !(map.none or map.connect.name == SOURCE_ATLAS): return false
	
	map.passage = Tiling.atlas(transition.execute, pos)
	return true
