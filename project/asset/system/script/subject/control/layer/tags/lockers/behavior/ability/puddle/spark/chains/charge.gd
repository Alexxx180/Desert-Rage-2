extends Node

signal activate()

var chains: Node
var border: TileDecorator
var execute: TileDecorator
var context: Dictionary

func init(map_coords: Vector2i) -> void:
	draw_source(map_coords, "ON")
	contact(map_coords)
	activate.emit(map_coords)

func diffuse_source(cell: Vector2i, tile: Dictionary) -> void:
	match border.from_coords(cell).context.atlas:
		FlowConductor.TILE.SOURCE.OFF: tile.cell = 1

func diffuse_puddle(cell: Vector2i, tile: Dictionary) -> bool:
	match execute.from_coords(cell).context.atlas:
		FlowConductor.TILE.PUDDLE.OFF: tile.cell = FlowConductor.SPARK
		_: diffuse_source(cell, tile)
	return tile.cell == FlowConductor.NONE # ==

func contact(map_coords: Vector2i) -> void:
	var tile: Dictionary = { "cell": FlowConductor.NONE }

	FlowConductor.around(map_coords, tile, func(cell: Vector2i, _c: Dictionary):
		return diffuse_puddle(cell, tile))

	match tile.cell: # if tile.cell > FlowConductor.NONE:
		FlowConductor.SOURCE: from_puddle(border.context.coords, tile.cell)
		FlowConductor.SPARK: from_puddle(execute.context.coords, tile.cell)

func _connection(chain: int, map_coords: Vector2i) -> bool:
	var track: Rect2 = chains.get_track(chain)

	if track.size == Vector2.ZERO:
		return chains.set_unit(chain, map_coords)

	if chains.search.is_at_edge(map_coords, track):
		return chains.extend_chain(chain, track.size)

	if map_coords != chains.last_unit(chain):
		return chains.add_unit(chain, map_coords)

	return false

func draw_source(map_coords: Vector2i, status: String) -> void:
	var source: Dictionary = FlowConductor.TILE.SOURCE
	border.target(map_coords).select(source[status], source.ID).paint()

func draw_puddle(map_coords: Vector2i, status: String) -> void:
	var puddle: Dictionary = FlowConductor.TILE.PUDDLE
	execute.target(map_coords).select(puddle[status], puddle.ID).paint()

func to_conductor(map_coords: Vector2i, chain: int, draw: Callable) -> void:
	if chains.can_extend(chain) and _connection(chain, map_coords):
		draw.call(map_coords, "ON")
		chains.shrink_size(chain)
		contact(map_coords)

func to_source(map_coords: Vector2i) -> void:
	chains.initiate_source(map_coords)
	to_conductor(map_coords, chains.last_chain(), draw_source)
	activate.emit(map_coords)

func to_puddle(map_coords: Vector2i) -> void:
	var chain: int = chains.search_path(map_coords)
	if chain == -1: return
	to_conductor(map_coords, chain, draw_puddle)

func from_puddle(map_coords: Vector2i, no: int) -> void:
	match no:
		FlowConductor.SOURCE: to_source(map_coords)
		FlowConductor.SPARK: to_puddle(map_coords)
		_: push_error("invalid electricity connection number")
