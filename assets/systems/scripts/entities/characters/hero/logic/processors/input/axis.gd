extends RefCounted

class_name InputAxis

var _axis: Callable
var axis: float: get = _get_axis
var dir: int: get = _get_direction

func _get_axis() -> float: return _axis.call()
func _get_direction() -> int: return int(_get_axis())

func _init(straight: String, opposite: String) -> void:
	_axis = func(): Input.get_axis(straight, opposite)
