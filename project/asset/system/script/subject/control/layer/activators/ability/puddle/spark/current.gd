extends Node

signal current_flow(map_coords: Vector2i)

const ID: int = 2
const SPARK: Vector2i = Vector2i(1, 2)

var current: Array[Array] = [] # Vector2i
var size: Array[int] = []
var _execute: TileDecorator
var execute: TileDecorator:
	get: return _execute
	set(value):
		_execute = value
		_execute.select(SPARK, ID)

@onready var drain: Node = $drain

enum { A = -2, B = -1, LENGTH = 10 }

func _ready() -> void:
	drain.flow = self

func at_edge(previous: Rect2i) -> bool:
	return execute.context.coords + previous.size == previous.position

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
	var path: Array[Vector2i] = current[i]
	return Vector2(path[B] - path[A])

func get_track(i: int) -> Rect2:
	return Rect2(current[i][B], get_delta(i))

func connection(map_coords: Vector2i) -> void:
	execute.target(map_coords)
	var i: int = search_path()
	var track: Rect2 = get_track(i)

	if track.size == Vector2.ZERO:
		current[i][B] = map_coords
	elif at_edge(track):
		current[i][B] += track.size
	else:
		current[i].append(map_coords)

	execute.paint()
	touch(map_coords)

func release(direction: Vector2i, i: int, j: int) -> void:
	var k: int = current[i].size()
	while k > j:
		execute.target(current[i][k]).paint()
		current[i].remove_at(k)
	current[i][j] += direction * -1

	var track: Rect2 = get_track(i)
	if track.size == Vector2.ZERO:
		touch(track.position)

func touch(map_coords: Vector2i) -> void: current_flow.emit(map_coords)
