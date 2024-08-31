extends Node

@onready var tilemap: Node = $tilemap

const DEFAULT: int = 0

var count: int = 0
var floors: Array[int] = []

var F: int:
	get: return DEFAULT if count == 0 else floors[-1]

func remove():
	floors.pop_front()
	count -= 1

func append(f: int):
	floors.push_back(f)
	count += 1

func set_control_entity(entity: Node2D, velocity: Node, geometry: CollisionShape2D):
	tilemap.set_control_entity(entity, velocity, geometry)

func _is_same(body: Node2D) -> bool:
	return body.get_instance_id() == get_instance_id()

func at_old_floor(body) -> void:
	if body is StaticBody2D:
		if not _is_same(body): remove()
	elif body is TileMap:
		remove()

func at_new_floor(body) -> void:
	var tile
	if body is StaticBody2D:
		if not _is_same(body): append(body.F)
	elif body is TileMap:
		tile = tilemap.find_tile(body)
		print("NEW FLOOR: ", tile)
		append(tile)
	print("Floors: ", F, ", DEF: ", DEFAULT)
