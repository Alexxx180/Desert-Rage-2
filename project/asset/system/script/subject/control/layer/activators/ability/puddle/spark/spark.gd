extends Node

@onready var particle = preload("res://asset/system/scene/subject/control/drive/rain.tscn")
@onready var chains: Node = $chains
@onready var alone: Node = $alone

var execute: TileDecorator:
	set(value):
		chains.execute = value
		alone.execute = value

func puddle_charge(map_coords: Vector2i, no: int) -> void:
	if not map_coords in alone.spark:
		chains.charge.from_puddle(map_coords, no)

func activate(pos: Vector2, direction: Vector2i) -> void:
	match alone.execute.from_pos(pos).context.atlas:
		Raining.SOURCE:
			chains.contact(alone.execute.context.coords)
		Raining.PUDDLE:
			alone.lazy_sparking(alone.execute.context.coords)
