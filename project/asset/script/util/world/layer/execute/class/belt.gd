class_name TilesBelt extends RefCounted

var offset: Dictionary = { "at": Vector2i.ZERO, "add": Vector2i(1, 0) }
var AS: Dictionary = {}

static func list(l: int, x: int, y: int, n_x: int, n_y: int = 0) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for i in range(0, l): result.append(Vector2i(x + n_x * i, y + n_y * i))
	return result

func has(value: Vector2i) -> bool: return value in AS.values()
func _init(x: int, y: int) -> void: from(x, y)

func _set_prop(prop: String, cell: Vector2i) -> TilesBelt:
	offset[prop] = cell
	return self

func from(x: int, y: int) -> TilesBelt: return _set_prop("at", Vector2i(x, y))
func next(x: int, y: int) -> TilesBelt: return _set_prop("add", Vector2i(x, y))

func add(key: String) -> TilesBelt:
	AS[key] = offset.at
	offset.at += offset.add
	return self
