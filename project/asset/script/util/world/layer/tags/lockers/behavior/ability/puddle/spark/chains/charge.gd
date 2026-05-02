extends Node

signal activate()

var chains: Node # var lay: Node
var context: Dictionary
var conductor: FlowConductor

func init(map_coords: Vector2i) -> void:
	conductor.draw_source(map_coords, "ON")
	contact(map_coords)
	activate.emit(map_coords)

func diffuse_puddle(tile: Dictionary) -> Callable:
	return func(cell: Vector2i, _c): conductor.diffuse_puddle(cell, tile)

func contact(map_coords: Vector2i) -> void:
	var tile: Dictionary = { "cell": FlowConductor.NONE }
	conductor.around(map_coords, tile, diffuse_puddle(tile))
	var coords: Vector2i = conductor.contact_coords(tile.cell)
	if coords != Def.VECTI: from_puddle(coords, tile.cell)

func _connection(chain: int, map_coords: Vector2i) -> bool:
	var track: Rect2 = chains.get_track(chain)

	if track.size == Vector2.ZERO:
		return Def.truth(chains.set_unit(chain, map_coords))

	if chains.search.is_at_edge(map_coords, track):
		return Def.truth(chains.extend_chain(chain, track.size))

	if map_coords != chains.last_unit(chain):
		return Def.truth(chains.add_unit(chain, map_coords))

	return false

func to_conductor(map_coords: Vector2i, chain: int, draw: Callable) -> void:
	if chains.can_extend(chain) and _connection(chain, map_coords):
		draw.call(map_coords, "ON")
		chains.shrink_size(chain)
		contact(map_coords)

func to_source(map_coords: Vector2i) -> void:
	chains.initiate_source(map_coords)
	to_conductor(map_coords, chains.last_chain(), conductor.draw_source)
	activate.emit(map_coords)

func to_puddle(map_coords: Vector2i) -> void:
	var chain: int = chains.search_path(map_coords)
	if chain == -1: return
	to_conductor(map_coords, chain, conductor.draw_puddle)

func from_puddle(map_coords: Vector2i, no: int) -> void:
	conductor.from_puddle(self, map_coords, no)
