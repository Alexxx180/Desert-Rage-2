extends Node

signal set_movement(is_floor: bool)

var unstable: bool:
	get: return not _stable

var _stable: bool = true
var stable: bool: get = _is_stable, set = set_stable

func _is_stable() -> bool:
	return _stable

func set_stable(is_floor: bool) -> void:
	if is_floor != _stable:
		set_movement.emit(is_floor)
		_stable = is_floor
