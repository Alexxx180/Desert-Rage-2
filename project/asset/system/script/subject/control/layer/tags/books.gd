extends Node

const SOURCE: int = 3

func get_message(tags: TileMapLayer, map_coords: Vector2i) -> int:
	var tile: Dictionary = Tile.from_coords(tags, map_coords)
	return Tile.logic(tile.atlas) - 1
# TODO BOOKS
func set_book(level: Dictionary, atlas: Vector2i, coords: Vector2i) -> void:
	var books: Dictionary = level.tags.manual.books
	if (books[atlas].size() > 0):
		var manual: String = books[atlas][0]#[message]
		level.execute.books[coords] = [atlas, manual]

func b(x: int, y: int) -> Vector2i: return Vector2i(x, y)
func set_books(level: Dictionary, tag: Vector2i) -> void:
	var tile: Dictionary = Tile.from_coords(level.border, tag)
	if [b(3, 0), b(3, 1), b(3, 2), b(3, 3), b(3, 4),
		b(4, 0), b(4, 1), b(4, 2), b(4, 3), b(4, 4)].has(tile.atlas):
		set_book(level, tile.atlas, tile.coords)

func set_page(level: Dictionary, tag: Vector2i, tile: Dictionary) -> void:
	var message: int = get_message(level.tags, tag)
	var manual: String = level.tags.manual.pages[message]
	level.execute.books[tile.coords] = [tile.atlas, manual]

func set_pages(level: Dictionary, tag: Vector2i) -> void:
	var tile: Dictionary = Tile.from_coords(level.execute, tag)
	match tile.atlas:
		Vector2i(2, 1): set_page(level, tag, tile)
		_: set_books(level, tag)

func setup(level: Dictionary) -> void:
	for tag in level.tags.get_used_cells_by_id(SOURCE):
		set_pages(level, tag)
