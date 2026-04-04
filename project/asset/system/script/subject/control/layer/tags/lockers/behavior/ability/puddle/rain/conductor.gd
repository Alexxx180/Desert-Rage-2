extends RefCounted

class_name FlowConductor

signal flow(map_coords: Vector2i, no: int)

enum { NONE = -1, SPARK = 0, SOURCE = 1 }

const SOURCE_OFF: Vector2i = Vector2i(4, 2)

var root: LevelRoot
var TILE: TilesTape = TilesTape.new(2, 2).next(2, 0).add("PUDDLE", 4).add("SOURCE", 0)

func puddle_flow(map_coords: Vector2i) -> void:
	flow.emit(map_coords, SPARK)

func sources_busy() -> Array[Vector2i]:
	return root.border.busy(TILE.ON.SOURCE, TILE.ID.SOURCE)

func from_puddle(charge: Node, map_coords: Vector2i, no: int) -> void:
	match no:
		SOURCE: charge.to_source(map_coords)
		SPARK: charge.to_puddle(map_coords)
		_: push_error("invalid electricity connection number")

func activate_puddle(ability: Node, pos: Vector2) -> void:
	if root.execute.from_pos(pos).tatlas == TILE.OFF.PUDDLE:
		ability.spark.lazy_sparking(root.execute.tcoords)
	else:
		ability.chains.activate_source(root.border, pos)

func contact_coords(cell: int) -> Vector2i:
	match cell: # if tile.cell > FlowConductor.NONE:
		SOURCE: return root.border.tcoords
		SPARK: return root.execute.tcoords
	return Def.VECTI

func activate_source(chains: Node, pos: Vector2) -> void:
	if root.border.from_pos(pos).tatlas == TILE.OFF.SOURCE:
		chains.contact(root.border.tcoords)

func diffuse_source(cell: Vector2i, context: Dictionary) -> void:
	if root.atlas("border", cell) == TILE.ON.SOURCE:
		context.charge = true

func diffuse_puddle(cell: Vector2i, context: Dictionary) -> bool:
	if root.atlas("execute", cell) == TILE.ON.PUDDLE:
		context.charge = true
	else:
		diffuse_source(cell, context)
	return not context.charge

func draw_source(map_coords: Vector2i, status: String) -> void:
	root.border.target(map_coords).select(TILE[status].SOURCE, TILE.ID.SOURCE).paint()

func draw_puddle(map_coords: Vector2i, status: String) -> void:
	root.execute.target(map_coords).select(TILE[status].PUDDLE, TILE.ID.PUDDLE).paint()

func rain_particle(rain: Node2D) -> void:
	root.execute.add_chip(rain, "..").select(TILE.OFF.PUDDLE, TILE.ID.PUDDLE).paint()

func set_puddle(cell: Vector2i, status: String) -> void:
	root.execute.select(TILE[status].PUDDLE, TILE.ID.PUDDLE).target(cell).paint()

func around(map_coords: Vector2i, context: Dictionary, check: Callable) -> bool:
	var search: bool = true
	var axis: int = Vector2.AXIS_Y

	while search and axis >= Vector2.AXIS_X:
		var offset: int = 3
		while search and offset > -1:
			offset -= 2
			var near: Vector2i = map_coords
			near[axis] += offset
			search = check.call(near, context)
		axis -= 1
	return search
