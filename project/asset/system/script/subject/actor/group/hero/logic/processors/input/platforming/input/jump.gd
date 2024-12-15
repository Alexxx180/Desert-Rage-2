extends Node

signal jump(control: Node, floors: TileMapLayer)

var available: bool = false

func jump_on(floors: TileMapLayer) -> bool:
	if available:
		jump.emit(self, floors)
	return available
