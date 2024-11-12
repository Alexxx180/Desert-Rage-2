extends Node

signal pass_impulse(impulse: float)

var _impulse: float = 0
var impulse: float: get = _get_impulse

func _get_impulse() -> float:
	return _impulse

func set_impulse(next: float) -> void:
	_impulse = next
	pass_impulse.emit(next)
