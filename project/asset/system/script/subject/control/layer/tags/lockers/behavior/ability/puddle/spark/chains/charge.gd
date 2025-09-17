extends Node

signal activate()

var chains: Node
var border: TileDecorator
var execute: TileDecorator

func init(map_coords: Vector2i) -> void:
	feedback(map_coords, FlowConductor.TILE.SOURCE.ON)
	contact(map_coords)
	activate.emit(map_coords)

func contact(map_coords: Vector2i) -> void:
	var tile: Dictionary = { "cell": FlowConductor.NONE }

	FlowConductor.around(map_coords, tile,
	(func(cell: Vector2i, context: Dictionary):
		match execute.from_coords(cell).context.atlas:
			FlowConductor.TILE.PUDDLE.OFF: tile.cell = 0
			FlowConductor.TILE.SOURCE.OFF: tile.cell = 1# 
		return tile.cell == FlowConductor.NONE))

	if tile.cell > FlowConductor.NONE: from_puddle(execute.context.coords, tile.cell)

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
	execute.target(map_coords).select(tile, FlowConductor.TILE.PUDDLE.ID).paint()

func to_conductor(map_coords: Vector2i, chain: int) -> bool:
	if chains.can_extend(chain) and _connection(chain, map_coords):
		chains.shrink_size(chain) # feedback(tile.position, tile.size)
		contact(map_coords)
		return true
	return false

func to_source(map_coords: Vector2i) -> void:
	chains.initiate_source(map_coords)
	if to_conductor(map_coords, chains.last_chain()):
		var t: Dictionary = FlowConductor.TILE.SOURCE
		border.target(map_coords).select(t.ON, t.ID).paint()
	activate.emit(map_coords)

func to_puddle(map_coords: Vector2i) -> void:
	var chain: int = chains.search_path(map_coords)
	if chain != -1 and to_conductor(map_coords, chain):
		feedback(map_coords, FlowConductor.TILE.PUDDLE.ON)

func from_puddle(map_coords: Vector2i, no: int) -> void:
	match no:
		1: to_source(map_coords)
		_: to_puddle(map_coords)
