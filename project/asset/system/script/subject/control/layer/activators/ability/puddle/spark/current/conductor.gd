extends Node

class_name FlowConductor

signal flow(map_coords: Vector2i)

static func get_offset() -> Array[Vector2i]:
	return [Vector2i(0, -1), Vector2i(0, 1), 
		Vector2i(-1, 0), Vector2i(1, 0)]

var execute: TileDecorator
var offset: Array[Vector2i] = get_offset()

func contact(map_coords: Vector2i) -> void:
	var charge: bool = false
	
	var i: int = offset.size()
	while i > 0 and not charge:
		i -= 1
		var tile: Vector2i = map_coords + offset[i]
		match execute.from_coords(tile).context.atlas:
			Vector2i(1, 2): charge = true
			Vector2i(1, 3): charge = true
	
	if charge:
		print("A CONTACT!")
		flow.emit(execute.context.coords)
	else:
		print("FLOW CHECK: ", execute.context.atlas)
