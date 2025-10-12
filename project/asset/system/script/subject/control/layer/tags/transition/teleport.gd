extends Node

class_name Transitions

var teleporters: Dictionary = {} # int, Node2D

const SOURCE_ID: int = 0
const MISSING: Vector2i = Vector2i(5, 0)

func get_target(border: TileDecorator) -> Array[Vector2i]:
	return border.layer.get_used_cells_by_id(SOURCE_ID, Vector2(2, 4))

func fill(lay: Node) -> void:
	for coords in get_target(lay.border):
		var cell: Vector2i = lay.tags.atlas_coords(coords) # assert(cell != Vector2i(-1, -1), "Target is not connected!")
		teleporters[cell] = lay.tags.layer.map_to_local(coords)

func transit(hero: CharacterBody2D, lay: Node) -> void:
	var cell: Vector2i = lay.tags.context.atlas
	if teleporters.has(cell):
		hero.to.act.teleport.teleport(teleporters[cell])
	else:
		lay.border.select(MISSING).paint()
		# assert(teleporters.has(cell), "Teleporter is not connected!")
