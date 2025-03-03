extends Node

@onready var particle = preload("res://asset/system/scene/subject/control/drive/rain.tscn")
@onready var chains: Node = $chains
@onready var direct: Node = $direct
@onready var timer: Timer = $timer

enum { DROP = 1, ID = 2, DIFFUSION = 5, LENGTH = 10 }

const SPARK: Vector2i = Vector2i(1, 2)

var _execute: TileDecorator
var execute: TileDecorator:
	get: return _execute
	set(value):
		_execute = value
		chains.execute = value

var unstable: Dictionary = {}
var timing: Array[Vector2i] = []
var size: int = 0

func diffusion() -> void:
	var s: int = timing.size()
	while s > 0:
		s -= 1
		var coords: Vector2i = timing[s]
		unstable[coords] -= DROP
		if unstable[coords] <= 0:
			execute.select(Raining.PUDDLE, ID).target(coords).paint()
			unstable.erase(coords)
			timing.remove_at(s)
			size -= 1
	if size == 0: timer.stop()

func sparking(_direction: Vector2i) -> void:
	var coords: Vector2i = execute.context.coords
	var near = (func(n): return not n in unstable)
	if direct.by(coords, near) != Vector2i.ZERO:
		size += 1
		execute.select(SPARK, ID).paint()
		unstable[coords] = DIFFUSION#s
		timing.append(coords)
	if size == 1: timer.start()

func puddle_charge(map_coords: Vector2i, no: int) -> void:
	if not map_coords in unstable:
		print("CHARGE")
		chains.charge.from_puddle(map_coords, no)

func activate(pos: Vector2, direction: Vector2i) -> void:
	match execute.from_pos(pos).context.atlas:
		Raining.SOURCE:
			execute.offset(Vector2i(1, 0)).paint()
			chains.initiate_source(execute.context.coords)
			chains.charge.contact(execute.context.coords)
			#current.touch(execute.context.coords)
			print("SK| ATLAS IS (S): ", execute.context.atlas)
		Raining.PUDDLE:
			sparking(direction)
			print("SK| ATLAS IS (Y): ", execute.context.atlas)
		_:
			print("SK| ATLAS IS (N): ", execute.context.atlas)
