extends RefCounted

class_name JumpTarget

signal jump(control: JumpTarget, border: TileMapLayer)

var available: bool = false

func jump_on(border: TileMapLayer) -> bool:
	if available:
		jump.emit(self, border)
	return available
