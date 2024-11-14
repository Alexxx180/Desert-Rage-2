extends Node

var _part: int = -1
var part: int:
	get: return _part

func set_stairs_position(level: int, next: Vector2) -> void:
	var transit: TileMapLayer = get_node("../..")
	var contact: Vector2 = next + Vector2.ONE
	_part = Tiles.get_int(transit, contact, "P", -1)

	if (_part == level):
		var group: Node2D = get_node("../../../group")
		group.position = next
