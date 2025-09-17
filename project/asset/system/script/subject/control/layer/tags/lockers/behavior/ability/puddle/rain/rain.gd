extends Node

signal flow(map_coords: Vector2i, no: int)

@onready var particle = preload("res://asset/system/scene/subject/control/drive/rain.tscn")

var border: TileDecorator
var execute: TileDecorator

func _atlas(layer: TileDecorator, coords: Vector2i) -> Vector2i:
	return layer.from_coords(coords).context.atlas

func diffuse_source(cell: Vector2i, context: Dictionary) -> void:
	var atlas = _atlas(border, cell)
	print("DIFFUSE SOURCE ATLAS: ", atlas)
	match atlas:
		FlowConductor.TILE.SOURCE.ON: context.charge = true
	print("CHARGED SOURCE: ", context.charge)

func diffuse_puddle(cell: Vector2i, context: Dictionary) -> bool:
	var atlas = _atlas(execute, cell)
	print("DIFFUSE PUDDLE ATLAS: ", atlas)
	match execute.from_coords(cell).context.atlas:
		FlowConductor.TILE.PUDDLE.ON:
			context.charge = true
			print("CHARGED PUDDLE: ", context.charge)
		_: diffuse_source(cell, context)
	return not context.charge

func diffusion(map_coords: Vector2i) -> void:
	var tile: Dictionary = { "charge": false }
	FlowConductor.around(map_coords, tile, diffuse_puddle)
	if tile.charge: flow.emit(map_coords, FlowConductor.SPARK)

func watering(direction: Vector2i) -> void:
	var t: Dictionary = FlowConductor.TILE.PUDDLE
	var rain = particle.instantiate()
	rain.set_pos(execute.context.pos).set_direction(direction)
	execute.add_chip(rain, "..").select(t.OFF, t.ID).paint()
	diffusion(execute.context.coords)

func activate(pos: Vector2, direction: Vector2i) -> void:
	match execute.from_pos(pos).context.atlas:
		Vector2(-1, -1): watering(direction)
