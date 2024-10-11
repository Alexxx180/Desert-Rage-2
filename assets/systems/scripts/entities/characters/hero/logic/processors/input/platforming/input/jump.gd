extends Node

signal jump(control: Node, floors: TileMapLayer)

var available: bool = false

func perform(floors: TileMapLayer) -> void:
	if available:
		print("AVAILABLE: ", name)
		jump.emit(self, floors)
