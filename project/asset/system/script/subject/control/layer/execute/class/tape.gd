class_name TilesTape extends RefCounted

var offset: Dictionary = { "at": Vector2i.ZERO, "add": Vector2i(0, 1), "on": Vector2i(1, 0) }
var OFF: Dictionary = {} ; var ON: Dictionary = {} ; var ID: Dictionary = {}

func off_at(value: Vector2i) -> bool: return value in OFF.values()
func on_at(value: Vector2i) -> bool: return value in ON.values()

func _init(x: int, y: int) -> void: from(x, y)

func _set_prop(prop: String, cell: Vector2i) -> TilesTape:
	offset[prop] = cell
	return self

func from(x: int, y: int) -> TilesTape: return _set_prop("at", Vector2i(x, y))
func next(x: int, y: int) -> TilesTape: return _set_prop("add", Vector2i(x, y))
func on(x: int, y: int) -> TilesTape: return _set_prop("on", Vector2i(x, y))

func add(key: String, id: int = -1) -> TilesTape:
	OFF[key] = offset.at
	ON[key] = offset.at + offset.on
	offset.at += offset.add
	if id != -1: ID[key] = id
	return self
