extends Node

@onready var particle = preload("res://asset/system/scene/subject/control/drive/rain.tscn")
@onready var direct: Node = $direct
@onready var timer: Timer = $timer

enum { DROP = 1, ID = 2, DIFFUSION = 5, LENGTH = 10 }

const PUDDLE: Vector2i = Vector2i(0, 2)
const SPARK: Vector2i = Vector2i(1, 2)

var execute: TileMapLayer
var unstable: Dictionary = {} # Vector2i, int
var path: Array[Vector2i] = []
var size: int = 0

func diffusion() -> void:
	for puddle in unstable:
		var cell: Dictionary = unstable[puddle]
		cell.time -= DROP#s
		if cell.time <= 0:
			cell.atlas = PUDDLE
			Tile.paint(execute, cell)
			unstable.erase(puddle)
			size -= 1
	if size == 0: timer.stop()

func sparking(tile: Dictionary, direction: Vector2i) -> void:
	var near: Callable = (func(near): not near in unstable)
	if direct.by(tile.coords, near) != Vector2.ZERO:
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
		Vector2i(0, 3):
			tile.atlas.x += 1
			Tile.paint(execute, tile)
		Vector2i(0, 2):
			sparking(tile, direction)
			print("AND NOW WHAT? ", tile.atlas)
		_:
			print("BUT ATLAS IS: ", tile.atlas)
			pass
