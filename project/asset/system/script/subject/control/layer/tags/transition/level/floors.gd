extends Node

func differ(layer: TileMapLayer, passage: Dictionary) -> int:
	return Tile.extract(layer, passage.coords, Tile.FLOOR)
