extends Node

@onready var chains: Node = $chains
@onready var alone: Node = $alone

var border: TileDecorator:
	set(value):
		chains.border = value

var execute: TileDecorator:
	set(value):
		chains.execute = value
		alone.execute = value

func puddle_charge(map_coords: Vector2i, no: int) -> void:
	if not map_coords in alone.spark:
		chains.charge.from_puddle(map_coords, no)

func activate_source(pos: Vector2) -> void:
	var context: Dictionary = chains.charge.border.from_pos(pos).context
	match context.atlas:
		FlowConductor.TILE.SOURCE.OFF:
			chains.contact(context.coords)

func activate_puddle(pos: Vector2) -> void:
	var context: Dictionary = alone.execute.from_pos(pos).context
	match context.atlas:
		FlowConductor.TILE.PUDDLE.OFF: alone.lazy_sparking(context.coords)
		_: activate_source(pos)

func activate(pos: Vector2) -> void: activate_puddle(pos)
