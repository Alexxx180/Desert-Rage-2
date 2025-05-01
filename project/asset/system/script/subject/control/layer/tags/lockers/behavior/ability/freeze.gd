extends Node

signal fire_drain(map_coords: Vector2i)

var execute: TileDecorator

@onready var particle = preload("res://asset/system/scene/subject/control/drive/fire.tscn")

func evaporation() -> void:
	var fire = particle.instantiate()
	fire.position = execute.context.pos
	execute.erase().add_chip(fire)
	fire_drain.emit(execute.context.coords)

func break_ice(damage: int) -> void:
	var resistance: int = execute.extract(Tile.BREAK)
	if resistance > damage: return
	evaporation()

func activate(pos: Vector2, damage: int) -> void:
	match execute.from_pos(pos).context.atlas:
		Vector2i(0, 2), Vector2i(1, 2): evaporation()
		Vector2i(2, 1), Vector2i(3, 1): break_ice(damage)
