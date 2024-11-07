extends Node

signal jump(control: Node, floors: TileMapLayer)

var available: bool = false

func perform(floors: TileMapLayer) -> void:
	if available:
		jump.emit(self, floors)
