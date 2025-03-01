extends Node

signal flow(map_coords: Vector2i, tile: int)

const NONE: int = -1

var execute: TileDecorator
var offset: Array[Vector2i] = FlowConductor.get_offset()

func contact(map_coords: Vector2i) -> void:
	var cell: int = NONE

	var i: int = offset.size()
	while i > 0 and cell == NONE:
		i -= 1
		var tile: Vector2i = map_coords + offset[i]
		match execute.from_coords(tile).context.atlas:
			Vector2i(0, 2): cell = 0
			Vector2i(0, 3): cell = 1
	
	if cell > NONE:
		print("A CONTACT!")
		flow.emit(execute.context.coords, cell)
	else:
		print("FLOW CHECK: ", execute.context.coords)
