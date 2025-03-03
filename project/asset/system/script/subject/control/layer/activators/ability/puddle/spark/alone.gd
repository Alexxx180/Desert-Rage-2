extends Node

enum { DROP = 1, ID = 2, DIFFUSION = 5, LENGTH = 10 }

@onready var timer: Timer = $diffuse

var execute: TileDecorator
var spark: Dictionary = {}
var cells: Array[Vector2i] = []
var size: int = 0

func set_puddle(cell: Vector2i, resize: int, type) -> void:
	execute.select(type.PUDDLE, type.ID).target(cell).paint()
	size = resize

func diffuse_puddle(item: int) -> void:
	var map_coords: Vector2i = cells[item]
	if spark[map_coords] <= 0:
		set_puddle(map_coords, size - 1, Raining)
		spark.erase(map_coords)
		cells.remove_at(item)

func lazy_sparking(map_coords: Vector2i) -> void:
	var can_place: bool = FlowConductor._around(map_coords, {},
		(func(cell: Vector2i, context: Dictionary):
			return not cell in spark))
	if can_place:
		set_puddle(map_coords, size + 1, Charger)
		spark[map_coords] = DIFFUSION
		cells.append(map_coords)
	if size == 1: timer.start()

func lazy_diffusion() -> void:
	var i: int = cells.size()
	while i > 0:
		i -= 1
		spark[cells[i]] -= DROP
		diffuse_puddle(i)
	if size == 0: timer.stop()
