extends Node

var execute: TileMapLayer

func activate(pos: Vector2) -> void:
	var tile: Dictionary = Tile.from_pos(execute, pos)
	print("FREEZE: ", tile.atlas)

	match tile.atlas:
		Vector2i(2, 1):
			execute.erase_cell(tile.coords)
		_: pass
