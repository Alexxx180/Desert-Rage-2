extends Node

signal set_movement(is_floor: bool)

var _stable: bool = true
var stable: bool:
	get: return _stable
	set(is_floor):
		if (is_floor != _stable):
			set_movement.emit(is_floor)
		_stable = is_floor

var unstable: bool:
	get: return not _stable
