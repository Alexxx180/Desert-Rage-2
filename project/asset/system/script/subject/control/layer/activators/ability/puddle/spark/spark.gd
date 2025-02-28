extends Node

@onready var particle = preload("res://asset/system/scene/subject/control/drive/rain.tscn")
@onready var direct: Node = $direct
@onready var timer: Timer = $timer

enum { DROP = 1, ID = 2, DIFFUSION = 5, LENGTH = 10 }

const PUDDLE: Vector2i = Vector2i(0, 2)
const SPARK: Vector2i = Vector2i(1, 2)

var execute: TileDecorator
var unstable: Dictionary = {}
var timing: Array[Vector2i] = []
var size: int = 0

func diffusion() -> void:
	execute.select(PUDDLE, ID)
	var s: int = timing.size()
	while s > 0:
		s -= 1
		unstable[s] -= DROP
		if unstable[s] <= 0:
			execute.target(unstable[s]).paint()
			unstable.erase(s)
			timing.remove_at(s)
			size -= 1
	if size == 0: timer.stop()

func sparking(direction: Vector2i) -> void:
	var coords: Vector2i = execute.context.coords
	var near: Callable = (func(near): not near in unstable)
	if direct.by(coords, near) != Vector2.ZERO:
		size += 1
		execute.select(SPARK, ID).paint()
		unstable[coords] = DIFFUSION#s
		timing.append(coords)
	if size == 1: timer.start()

func activate(pos: Vector2, direction: Vector2i) -> void:
	match execute.from_pos(pos).context.atlas:
		Vector2i(0, 3):
			execute.offset(Vector2i(1, 0)).paint()
		Vector2i(0, 2):
			sparking(direction)
			print("SK| ATLAS IS (Y): ", execute.context.atlas)
		_:
			print("SK| ATLAS IS (N): ", execute.context.atlas)
