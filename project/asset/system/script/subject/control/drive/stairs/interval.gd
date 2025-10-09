extends Node

var _part: int = -1
var part: int:
	get: return _part

func set_stairs_position(level: int, next: Vector2) -> void:
	var group: Node2D = get_node("../../../group")
	var transit: TileMapLayer = hero.group.lay.tags

	var contact: Vector2 = next + Vector2.ONE
	_part = transit.extract_at_pos(contact, Tile.LEVEL)

	if (_part == level): group.position = next
