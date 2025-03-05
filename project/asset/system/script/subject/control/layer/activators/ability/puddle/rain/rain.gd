extends Node

class_name Raining

signal flow(map_coords: Vector2i, no: int)

enum { SPARK = 0, ID = 2 }

@onready var particle = preload("res://asset/system/scene/subject/control/drive/rain.tscn")

const PUDDLE: Vector2i = Vector2i(0, 2)
const SOURCE: Vector2i = Vector2i(0, 3)

var execute: TileDecorator

func diffusion(map_coords: Vector2i) -> void:
	var tile: Dictionary = { "charge": false }
	
	FlowConductor.around(map_coords, tile,
	(func(cell: Vector2i, context: Dictionary):
		match execute.from_coords(cell).context.atlas:
			Charger.PUDDLE: context.charge = true
			Charger.SOURCE: context.charge = true
		return not context.charge))

	if tile.charge: flow.emit(map_coords, SPARK)

func watering(direction: Vector2i) -> void:
	var rain = particle.instantiate()
	rain.set_pos(execute.context.pos).set_direction(direction)
	execute.add_chip(rain, "..").select(PUDDLE, ID).paint()
	diffusion(execute.context.coords)

func activate(pos: Vector2, direction: Vector2i) -> void:
	match execute.from_pos(pos).context.atlas:
		Vector2(-1, -1): watering(direction)
