extends Node

const SOURCE: int = 3

func _message(level: Dictionary, map_coords: Vector2i) -> int:
	return level.tags.from_coords(map_coords).logic_no - 1
# TODO BOOKS
func check_book(level: Dictionary, tile: Dictionary) -> void:
	var books: Dictionary = level.tags.manual.books
	if (books[tile.atlas].size() > 0):
		var manual: String = books[tile.atlas][0]#[message]
		set_book(level, tile.coords, [tile.atlas, manual])

func b(x: int, y: int) -> Vector2i: return Vector2i(x, y)
func set_books(level: Dictionary, tag: Vector2i) -> void:
	var tile: Dictionary = level.border.from_coords(tag).context
	if [b(3, 0), b(3, 1), b(3, 2), b(3, 3), b(3, 4),
		b(4, 0), b(4, 1), b(4, 2), b(4, 3), b(4, 4)].has(tile.atlas):
		check_book(level, tile)

func set_book(level: Dictionary, coords: Vector2i, value: Array) -> void:
	level.execute.books[coords] = value

func _manual(level: Dictionary, message: int) -> String:
	return level.tags.manual.pages[message]

func set_page(level: Dictionary, tile: Dictionary) -> void:
	set_book(level, tile.coords, [tile.atlas,
		_manual(_message(level, tile.coords))])

func set_pages(level: Dictionary, tag: Vector2i) -> void:
	var tile: Dictionary = level.execute.from_coords(tag).context
	match tile.atlas:
		Vector2i(2, 1): set_page(level, tile)
		_: set_books(level, tag)

func setup(level: Dictionary) -> void:
	for tag in level.tags.get_used_cells_by_id(SOURCE):
		set_pages(level, tag)
