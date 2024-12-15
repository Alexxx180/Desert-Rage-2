extends Node

var _velocity: int = 0
var velocity: int: get = _get_velocity

func _get_velocity() -> int:
	return _velocity

func set_velocity(next: int) -> void:
	_velocity = next
