extends Node

signal fire_drain(map_coords: Vector2i)

var execute: TileDecorator

@onready var particle: PackedScene = preload("res://asset/system/scene/subject/particle/fire.tscn")

func evaporation() -> void:
	execute.erase().add_chip(particle.instantiate())
	fire_drain.emit(execute.context.coords)

func break_ice(damage: int) -> void:
	if execute.extract(Tile.BREAK) <= damage:
		evaporation()

func activate(pos: Vector2, damage: int) -> void:
	match execute.from_pos(pos).context.atlas:
		Vector2i(2, 1), Vector2i(3, 1): break_ice(damage)
		Vector2i(2, 2), Vector2i(3, 2): evaporation()
