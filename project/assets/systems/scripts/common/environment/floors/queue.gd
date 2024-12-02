extends RefCounted

class_name FloorsQueue

signal update(F: int)

const GROUND: int = 0

var count: int = 0
var floors: Array[int] = []

var F: int: get = _get_last_floor

func _get_last_floor() -> int:
	return GROUND if count == 0 else floors[-1]

func _update(next: int) -> void:
	count = next
	update.emit(_get_last_floor())

func remove() -> void:
	#print("OLD F: ", _get_last_floor())
	floors.pop_front()
	_update(count - 1)

func append(f: int) -> void:
	#print("NEW F: ", f)
	floors.push_back(f)
	_update(count + 1)
