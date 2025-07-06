extends Node

signal jump(control: Node, border: TileMapLayer)

var available: bool = false

func jump_on(border: TileMapLayer) -> bool:
	if available:
		jump.emit(self, border)
	return available
