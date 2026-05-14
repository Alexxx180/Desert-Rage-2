class_name TilesTape extends RefCounted

enum { AT, ADD, TO }
enum BORDER { LOGIC = 0, TRANSITION = 3 }
enum EXECUTE { BOOKS = 2, HOOKUPS = 4, LOGIC = 7, TRANSITION = 8, CHATS = 6, CHEST = 9, ENEMY = 10 }
enum {}

var offset: PackedVector2Array = [Vector2i.ZERO, Vector2i(0, 1), Vector2i(1, 0)]
var tiles: PackedVector2Array
var OFF: Dictionary = {} ; var ON: Dictionary = {}
var inventory: Dictionary[String, int] = {}

func off_at(value: Vector2i) -> bool: return value in OFF.values()
func on_at(value: Vector2i) -> bool: return value in ON.values()

func _init(x: int, y: int, size: int) -> void:
	tiles.resize(size)
	from(x, y)

func _set_prop(prop: int, cell: Vector2i) -> TilesTape:
	offset[prop] = cell
	return self

func from(x: int, y: int) -> TilesTape: return _set_prop(AT, Vector2i(x, y))
func next(x: int, y: int) -> TilesTape: return _set_prop(ADD, Vector2i(x, y))
func on(x: int, y: int) -> TilesTape: return _set_prop(TO, Vector2i(x, y))

func add(key: String) -> TilesTape:
	inventory[key] = inventory.size()
	OFF[key] = offset[AT]
	ON[key] = offset[AT] + offset[TO]
	offset[AT] += offset[ADD]
	return self
