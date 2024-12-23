extends Node

var _F: int = 0
var F: int: get = _get_floor

var freeze: bool = false

func _get_floor() -> int:
	return _F

func set_floor(next: int) -> void:
	if (not freeze):
		_F = next
		print("but come back to: ", F)
	else:
		print("already set as: ", F)

func set_box_floor(next: int) -> void:
	_F = next
	print("set box floor: ", F)
