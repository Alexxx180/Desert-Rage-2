extends Node

enum { A = -2, B = -1, LENGTH = 10 }

var current: Array[Array] = [] # Vector2i
var size: Array[int] = []

@onready var search: Node = $search
@onready var charge: Node = $charge
@onready var drain: Node = $drain

var execute: TileDecorator:
	set(layer):
		charge.execute = layer
		initiate(layer.busy(Charger.SOURCE, Charger.ID))

func _ready() -> void:
	drain.chains = self
	charge.chains = self

func initiate(tiles: Array[Vector2i]) -> void:
	for map_coords in tiles: initiate_source(map_coords)

func initiate_source(map_coords: Vector2i) -> void:
	current.append([map_coords, map_coords])
	size.append(LENGTH)

func get_track(chain: int) -> Rect2i:
	var path: Array = current[chain]
	return search.get_track(path[A], path[B])

func last_unit(chain: int) -> Vector2i:
	return get_unit(chain, B)

func closing_unit(chain: int) -> Vector2i:
	return get_unit(chain, A)

func last_delta(map_coords: Vector2i, chain: int) -> Vector2i:
	return map_coords - last_unit(chain)

func search_path(map_coords: Vector2i) -> int:
	return search.get_chain(self, map_coords)

func get_path_site(tile: Dictionary) -> Vector2i:
	return get_site(tile.chain, tile.map_coords, tile.joint)

func get_site(chain: int, map_coords: Vector2i, unit: int = B) -> Vector2i:
	return search.get_direction(map_coords - current[chain][unit - 1])

func get_chain(chain: int) -> Array: return current[chain]

func get_unit(chain: int, unit: int) -> Vector2i:
	return current[chain][unit]

func set_unit(chain: int, map_coords: Vector2i) -> bool:
	current[chain][B] = map_coords
	return true

func add_unit(chain: int, map_coords: Vector2i) -> bool:
	current[chain].append(map_coords)
	return true

func extend_chain(chain: int, map_coords: Vector2i) -> bool:
	set_unit(chain, last_unit(chain) + map_coords)
	return true

func last_chain() -> int: return current.size() - 1

func drop_unit(chain: int) -> void: current[chain].pop_back()

func length(chain: int) -> int: return current[chain].size()
