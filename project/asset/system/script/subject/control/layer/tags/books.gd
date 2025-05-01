extends Node

const SOURCE: int = 3

func get_message(tags: TileMapLayer, map_coords: Vector2i) -> int:
	var tile: Dictionary = Tile.from_coords(tags, map_coords)
	return Tile.logic(tile.atlas) - 1

func setup(tags: TileMapLayer, execute: TileMapLayer) -> void:
	for tag in tags.get_used_cells_by_id(SOURCE):
		var tile: Dictionary = Tile.from_coords(execute, tag)
		var message: int = get_message(tags, tag)
		var manual: String
		match tile.atlas:
			Vector2i(2, 1): manual = tags.manual.pages[message]
			_: manual = tags.manual.books[tile.atlas][message]
		execute.books[tile.coords] = [tile.atlas, manual]
