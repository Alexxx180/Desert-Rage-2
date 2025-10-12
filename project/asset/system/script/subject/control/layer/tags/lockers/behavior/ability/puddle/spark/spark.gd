extends Node

@onready var chains: Node = $chains
@onready var alone: Node = $alone

var _lay: Node
var lay: Node:
	set(value):
		_lay = value
		chains.lay = value
		alone.execute = value.execute

func puddle_charge(map_coords: Vector2i, no: int) -> void:
	if not map_coords in alone.spark:
		chains.charge.from_puddle(map_coords, no)

func activate_source(pos: Vector2) -> void:
	match _lay.border.from_pos(pos).context.atlas:
		FlowConductor.TILE.SOURCE.OFF:
			chains.contact(_lay.border.context.coords)

func activate_puddle(pos: Vector2) -> void:
	match _lay.execute.from_pos(pos).context.atlas:
		FlowConductor.TILE.PUDDLE.OFF:
			alone.lazy_sparking(_lay.execute.context.coords)
		_: activate_source(pos)

func activate(pos: Vector2) -> void: activate_puddle(pos)
