extends Node

var teleporters: Dictionary = {} # int, Node2D

const SOURCE_ID = 1

func get_target(execute: TileMapLayer) -> Array[Vector2i]:
	return execute.get_used_cells_by_id(SOURCE_ID, Vector2(2, 2))

func fill(tags: TileMapLayer, execute: TileMapLayer) -> void:
	for coords in get_target(execute):
		var cell: Vector2i = Tiling.source(tags, coords)
		assert(cell != Vector2i(-1, -1), "Target is not connected!")
		teleporters[cell] = tags.map_to_local(coords)

func transit(hero: CharacterBody2D, logic: Dictionary) -> void:
	assert(logic.name != "none", "Teleporter is not connected!")
	hero.teleport(teleporters[logic.cell])