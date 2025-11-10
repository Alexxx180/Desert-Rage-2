extends Node

class_name TilesTape

var offset: Dictionary = { "at": Vector2i.ZERO, "add": Vector2i(0, 1), "on": Vector2i(1, 0) }
var OFF: Dictionary = {}
var ON: Dictionary = {}

static func list(l: int, x: int, y: int, n_x: int, n_y: int = 0) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for i in range(0, l): result.append(Vector2i(x + n_x * i, y + n_y * i))
	return result

func _increment() -> void: offset.at += offset.next

func off_at(value: Vector2i) -> bool: return value in OFF.values()
func on_at(value: Vector2i) -> bool: return value in ON.values()

func _init(x: int, y: int) -> void: from(x, y)

func from(x: int, y: int) -> TilesTape:
	offset.at = Vector2i(x, y)
	return self

func next(x: int, y: int) -> TilesTape:
	offset.add = Vector2i(x, y)
	return self

func on(x: int, y: int) -> TilesTape:
	offset.on = Vector2i(x, y)
	return self

func add(key: String) -> TilesTape:
	OFF[key] = offset.at
	ON[key] = offset.at + offset.on
	offset.at += offset.add
	return self
