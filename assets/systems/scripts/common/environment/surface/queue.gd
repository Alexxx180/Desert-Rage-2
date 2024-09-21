extends RefCounted

class_name FloorsQueue

signal on_floor_change(F: int)

const GROUND: int = 0

var count: int = 0
var floors: Array[int] = []

var F: int: get = _get_last_floor

func _get_last_floor() -> int:
	return GROUND if count == 0 else floors[-1]

func remove():
	print("OLD F: ", F)
	floors.pop_front()
	count -= 1
	on_floor_change.emit(F)

func append(f: int):
	print("NEW F: ", f)
	floors.push_back(f)
	count += 1
	on_floor_change.emit(F)
