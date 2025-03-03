extends Node

class_name Charger

enum { NONE = -1, ID = 2 }
const SOURCE: Vector2i = Vector2i(1, 3)
const PUDDLE: Vector2i = Vector2i(1, 2)

var chains: Node
var execute: TileDecorator

func contact(map_coords: Vector2i) -> void:
	var tile: Dictionary = { "cell": NONE }

	FlowConductor.around(map_coords, tile,
	(func(cell: Vector2i, context: Dictionary):
		match execute.from_coords(cell).context.atlas:
			Raining.PUDDLE: tile.cell = 0
			Raining.SOURCE: tile.cell = 1
		return tile.cell == NONE))

	if tile.cell > NONE: from_puddle(execute.context.coords, tile.cell)

func _connection(chain: int, map_coords: Vector2i) -> bool:
	var track: Rect2 = chains.get_track(chain)

	if track.size == Vector2.ZERO:
		return chains.set_unit(chain, map_coords)

	if chains.search.is_at_edge(map_coords, track):
		return chains.extend_chain(chain, track.size)

	if map_coords != chains.last_unit(chain):
		return chains.add_unit(chain, map_coords)

	return false

func feedback(map_coords: Vector2i, tile: Vector2i) -> void:
	execute.target(map_coords).select(tile, ID).paint()

func to_conductor(tile: Rect2i, chain: int) -> void:
	if _connection(chain, tile.position):
		feedback(tile.position, tile.size)
		contact(tile.position)

func to_source(map_coords: Vector2i) -> void:
	chains.initiate_source(map_coords)
	to_conductor(Rect2i(map_coords, SOURCE), chains.last_chain())

func to_puddle(map_coords: Vector2i) -> void:
	var chain: int = chains.search_path(map_coords)
	if chain == -1: return
	to_conductor(Rect2i(map_coords, PUDDLE), chain)

func from_puddle(map_coords: Vector2i, no: int) -> void:
	match no:
		1: to_source(map_coords)
		_: to_puddle(map_coords)
