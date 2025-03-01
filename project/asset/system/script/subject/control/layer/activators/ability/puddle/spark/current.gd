extends Node

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

var i: int

func _ready() -> void:
	drain.flow = self
	charge.flow.connect(puddle)

func at_edge(previous: Rect2) -> bool:
	#print("EDGE: ", execute.context.coords, " - ", previous.position, " =? ", previous.size.normalized())
	return Vector2(execute.context.coords) - previous.position == previous.size.normalized()

func initiate_source(map_coords: Vector2i) -> void:
	current.append([map_coords, map_coords])
	size.append(LENGTH)

func is_near(direction: Vector2i) -> bool:
	var x: bool = direction.x == 0 and abs(direction.y) == 1 
	var y: bool = direction.y == 0 and abs(direction.x) == 1 
	return x or y

func search_path() -> int:
	var coords: Vector2i = execute.context.coords
	i = current.size() - 1
	while i >= 0 and is_near(coords - current[i][B]): i -= 1
	return i

func get_delta() -> Vector2:
	var path: Array = current[i]
	#print("PATH: A = ", path[A], ", B = ", path[B])
	#print("CURRENT IS: ", current)
	return Vector2(path[B] - path[A])

func get_track(chain: int = i) -> Rect2:
	return Rect2(current[chain][B], get_delta())

func puddle(map_coords: Vector2i, no: int = 0) -> void:
	if no == 1:
		#current[i].pop_back()
		initiate_source(map_coords)
	execute.select(tiles.SPARK[no], ID).target(map_coords)
	connection()

func connection() -> void:
	var map_coords: Vector2i = execute.context.coords
	i = search_path()
	var track: Rect2 = get_track()

	if track.size == Vector2.ZERO:
		current[i][B] = map_coords
		print("START!!")
	#elif map_coords == current[i][B]:
		#return
	elif at_edge(track):
		print("AT EDGE!!")
		current[i][B] += Vector2i(track.size.normalized())
	elif not map_coords == current[i][B]:
		current[i].append(map_coords)

	execute.paint()
	touch(map_coords)

func release(map_coords: Vector2i, chain: int, joint: int) -> void:
	var direction: Vector2i
	var position: Vector2i
	print("TRY [REMOVE]: CURRENT = ", chain, " UNIT = ", joint)
	while current[chain].size() > joint:
		position = current[chain][B]
		direction = Vector2(current[chain][B] - current[chain][A]).normalized()
		while position != current[chain][A]:
			execute.target(current[chain][B]).select(tiles.PUDDLE).paint()
			print("[REMOVE][", chain, "] ", current[chain][B])
			position += direction
		current[chain].pop_back()# remove_at(current[chain].size() - 1)
	
	position = current[chain][B]
	direction = Vector2(current[chain][B] - current[chain][A]).normalized() * -1
	while position != map_coords:
		#execute.target(position).select(tiles.PUDDLE).paint()
		execute.erase(position)
		print("[PAINT][", chain, "] ", position, " > TO > ", map_coords)
		# remove_at(current[chain].size() - 1)
		position += direction
	current[chain][B] = map_coords
			
	#direction = current[chain][-1] - current[chain][joint - 1]
	#current[chain][joint - 1] = map_coords
	#if not same:
	#	current[chain].append(map_coords)
	# current[chain][joint] = Vector2(map_coords) # i j

	#var track: Rect2 = get_track(chain)
	#if track.size == Vector2.ZERO:
	touch(current[chain][B])
	#touch(track.position)

func touch(map_coords: Vector2i) -> void:
	#print("EXECUTING: ", map_coords)
	charge.contact(map_coords)
