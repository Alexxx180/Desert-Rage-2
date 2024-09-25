extends RefCounted

class_name InputAxis

var _straight: String
var _opposite: String

var axis: float: get = _get_axis
var dir: int: get = _get_direction

func _get_axis() -> float: return Input.get_axis(_straight, _opposite)
func _get_direction() -> int: return int(_get_axis())

func _init(straight: String, opposite: String) -> void:
	_straight = straight
	_opposite = opposite
