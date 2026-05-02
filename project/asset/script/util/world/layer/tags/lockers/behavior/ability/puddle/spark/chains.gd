extends Node

enum { A = -2, B = -1, LENGTH = 10 }

var current: Array[Array] = [] # Vector2i
var size: Array[int] = []

@onready var search: Node = $search
@onready var charge: Node = $charge
@onready var drain: Node = $drain

func _ready() -> void:
	drain.chains = self
	charge.chains = self

func set_conductor(conductor: FlowConductor) -> void:
	charge.conductor = conductor
	initiate(conductor.sources_busy())

func contact(map_coords: Vector2i) -> void:
	initiate_source(map_coords)
	charge.init(map_coords)

func initiate_source(map_coords: Vector2i) -> void:
	current.append([map_coords, map_coords])
	size.append(LENGTH)

func get_track(chain: int) -> Rect2i:
	var path: Array = get_chain(chain)
	return search.get_track(path[A], path[B])

func initiate(tiles: Array[Vector2i]) -> void:
	for map_coords in tiles: initiate_source(map_coords)

func activate_source(pos: Vector2) -> void:
	charge.conductor.activate_source(self, pos)

func last_unit(chain: int) -> Vector2i: return get_unit(chain, B)

func closing_unit(chain: int) -> Vector2i: return get_unit(chain, A)

func last_delta(map_coords: Vector2i, chain: int) -> Vector2i:
	return map_coords - last_unit(chain)

func search_path(map_coords: Vector2i) -> int:
	return search.get_chain(self, map_coords)

func get_path_site(tile: Dictionary) -> Vector2i:
	return get_site(tile.chain, tile.map_coords, tile.joint)

func get_site(chain: int, map_coords: Vector2i, unit: int = B) -> Vector2i:
	return search.get_direction(map_coords - current[chain][unit - 1])

func get_chain(chain: int) -> Array: return current[chain]

func get_unit(chain: int, unit: int) -> Vector2i: return current[chain][unit]

func set_unit(chain: int, map_coords: Vector2i):
	current[chain][B] = map_coords

func add_unit(chain: int, map_coords: Vector2i):
	current[chain].append(map_coords)

func drop_unit(chain: int) -> void:
	current[chain].pop_back()

func extend_chain(chain: int, map_coords: Vector2i):
	set_unit(chain, last_unit(chain) + map_coords)

func shrink_chain(chain: int, direction: Vector2i) -> void:
	set_unit(chain, last_unit(chain) + -direction)

func can_extend(chain) -> bool: return size[chain] > 0

func extend_size(chain) -> void: size[chain] += 1

func shrink_size(chain) -> void: size[chain] -= 1

func last_chain() -> int: return current.size() - 1

func length(chain: int) -> int: return current[chain].size()
