extends RefCounted

class_name InputAxis

var _axis: Callable
var axis: float: get = _get_axis

func _get_axis() -> float: return _axis.call()

func _init(straight: String, opposite: String) -> void:
	_axis = func(): Input.get_axis(straight, opposite)
