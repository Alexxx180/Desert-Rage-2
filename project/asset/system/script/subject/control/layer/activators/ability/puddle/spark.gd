extends Node

@onready var particle = preload("res://asset/system/scene/subject/control/drive/rain.tscn")
@onready var timer: Timer = $timer

enum { DROP = 1, ID = 2, DIFFUSION = 5, LENGTH = 10 }

const PUDDLE: Vector2i = Vector2i(0, 2)
const SPARK: Vector2i = Vector2i(1, 2)

var execute: TileMapLayer
var unstable: Dictionary = {} # Vector2i, int
var path: Array[Vector2i] = []
var size: int = 0

func diagonal(map_coords: Vector2i) -> bool:
	var i: int = 2
	var can_spark: bool = true
	while (can_spark and i > 0):
		i -= 1
		var j: int = 3
		while (can_spark and j > -1):
			j -= 2
			var near: Vector2i = map_coords
			near[i] += j
			can_spark = not near in unstable
	return can_spark

func diffusion() -> void:
	for puddle in unstable:
		unstable[puddle].time -= DROP#s
		if unstable[puddle].time <= 0:
			unstable[puddle].atlas = PUDDLE
			Tile.paint(execute, unstable[puddle])
			unstable.erase(puddle)
			size -= 1
	if size == 0: timer.stop()

func sparking(tile: Dictionary, direction: Vector2i) -> void:
	if diagonal(tile.coords):
		size += 1
		tile.atlas = SPARK
		tile.id = ID
		tile.time = DIFFUSION#s
		Tile.paint(execute, tile)
		unstable[tile.coords] = tile
	if size == 1: timer.start()

func activate(pos: Vector2, direction: Vector2i) -> void:
	var tile: Dictionary = Tile.from_pos(execute, pos)
	match tile.atlas:
		Vector2i(0, 2):
			sparking(tile, direction)
			print("AND NOW WHAT? ", tile.atlas)
		_:
			print("BUT ATLAS IS: ", tile.atlas)
			pass
