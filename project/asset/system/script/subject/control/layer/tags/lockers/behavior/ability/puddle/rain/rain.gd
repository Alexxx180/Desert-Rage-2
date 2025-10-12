extends Node

signal flow(map_coords: Vector2i, no: int)

@onready var particle: PackedScene = preload("res://asset/system/scene/subject/particle/rain.tscn")

var lay: Node

func diffuse_source(cell: Vector2i, context: Dictionary) -> void:
	match lay.atlas("border", cell):
		FlowConductor.TILE.SOURCE.ON: context.charge = true

func diffuse_puddle(cell: Vector2i, context: Dictionary) -> bool:
	match lay.atlas("execute", cell):
		FlowConductor.TILE.PUDDLE.ON: context.charge = true
		_: diffuse_source(cell, context)
	return not context.charge

func diffusion(map_coords: Vector2i) -> void:
	var tile: Dictionary = { "charge": false }
	FlowConductor.around(map_coords, tile, diffuse_puddle)
	if tile.charge: flow.emit(map_coords, FlowConductor.SPARK)

func watering(direction: Vector2i) -> void:
	var t: Dictionary = FlowConductor.TILE.PUDDLE
	var rain: Node2D = particle.instantiate()
	lay.execute.add_chip(rain, "..").select(t.OFF, t.ID).paint() # rain.set_direction(direction)
	diffusion(lay.execute.context.coords)

func activate(pos: Vector2, direction: Vector2i) -> void:
	match lay.execute.from_pos(pos).context.atlas:
		Vector2(-1, -1): watering(direction) #; print("WATERING")
		_: print("CANT WATERING")
