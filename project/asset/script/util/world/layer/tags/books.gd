extends Node

const SOURCE: int = 3

func _message(lay: Node, map_coords: Vector2i) -> int:
	return lay.tags.from_coords(map_coords).logic_no - 1
# TODO BOOKS
func check_book(lay: Node, tile: Dictionary) -> void:
	var books: Dictionary = lay.tags.manual.books
	if (books[tile.atlas].size() > 0):
		var manual: String = books[tile.atlas][0]#[message]
		set_book(lay, tile.coords, [tile.atlas, manual])

func b(x: int, y: int) -> Vector2i: return Vector2i(x, y)
func set_books(lay: Node, tag: Vector2i) -> void:
	var tile: Dictionary = lay.border.from_coords(tag).context
	if [b(3, 0), b(3, 1), b(3, 2), b(3, 3), b(3, 4),
		b(4, 0), b(4, 1), b(4, 2), b(4, 3), b(4, 4)].has(tile.atlas):
		check_book(lay, tile)

func set_book(lay: Node, coords: Vector2i, value: Array) -> void:
	lay.execute.books[coords] = value

func _manual(lay: Node, coords: Vector2i) -> String:
	return lay.tags.manual.pages[_message(lay, coords)]

func set_page(lay: Node, tile: Dictionary) -> void:
	set_book(lay, tile.coords, [tile.atlas, _manual(lay, tile.coords)])

func set_pages(lay: Node, tag: Vector2i) -> void:
	var tile: Dictionary = lay.execute.from_coords(tag).context
	match tile.atlas:
		Vector2i(2, 1): set_page(lay, tile)
		_: set_books(lay, tag)

func setup(lay: Node) -> void:
	for tag in lay.tags.layer.get_used_cells_by_id(SOURCE):
		set_pages(lay, tag)
