extends Node

signal current_flow(pos: Vector2)

const ID: int = 2
var tiles = {
	"PUDDLE": Vector2i(0, 2),
	"SPARK": [Vector2i(1, 2), Vector2i(1, 3)],
	"SOURCE": Vector2i(2, 2)
}

var current: Array[Array] = [] # Vector2i
var size: Array[int] = []
var _execute: TileDecorator
var execute: TileDecorator:
	get: return _execute
	set(value):
		_execute = value
		charge.execute = value
		for map_coords in execute.busy(tiles.SOURCE, ID):
			initiate_source(map_coords)

@onready var drain: Node = $drain
@onready var charge: Node = $charge

enum { A = -2, B = -1, LENGTH = 10 }

func _ready() -> void:
	drain.flow = self
	charge.flow.connect(puddle)

func at_edge(previous: Rect2) -> bool:
	print("EDGE: ", execute.context.coords, " - ", previous.position, " =? ", previous.size.normalized())
	return Vector2(execute.context.coords) - previous.position == previous.size.normalized()

func initiate_source(map_coords: Vector2i) -> void:
	current.append([map_coords, map_coords])
	size.append(LENGTH)

func is_near(direction: Vector2i) -> bool:
	return direction.x == 0 or direction.y == 0

func search_path() -> int:
	var coords: Vector2i = execute.context.coords
	var i: int = current.size() - 1
	while i >= 0 and is_near(coords - current[i][B]): i -= 1
	return i

func get_delta(i: int) -> Vector2:
	var path: Array = current[i]
	print("PATH: A = ", path[A], ", B = ", path[B])
	print("CURRENT IS: ", current)
	return Vector2(path[B] - path[A])

func get_track(i: int) -> Rect2:
	return Rect2(current[i][B], get_delta(i))

func puddle(map_coords: Vector2i, no: int = 0) -> void:
	execute.select(tiles.SPARK[no], ID).target(map_coords)
	connection()

func connection() -> void:
	var map_coords: Vector2i = execute.context.coords
	var i: int = search_path()
	var track: Rect2 = get_track(i)

	if track.size == Vector2.ZERO:
		current[i][B] = map_coords
		print("START!!")
	#elif map_coords == current[i][B]:
		#return
	elif at_edge(track):
		print("AT EDGE!!")
		current[i][B] += Vector2i(track.size)
	elif not map_coords == current[i][B]:
		current[i].append(map_coords)

	execute.paint()
	touch(map_coords)

func release(direction: Vector2i, i: int, j: int) -> void:
	var k: int = current[i].size()
	while k >= j:
		k -= 1
		execute.target(current[i][k]).select(tiles.PUDDLE).paint()
		current[i].remove_at(k)
	current[i][k - 1] += direction * -1 # i j

	var track: Rect2 = get_track(i)
	if track.size == Vector2.ZERO:
		touch(track.position)

func touch(map_coords: Vector2i) -> void:
	#print("EXECUTING: ", map_coords)
	charge.contact(map_coords)
