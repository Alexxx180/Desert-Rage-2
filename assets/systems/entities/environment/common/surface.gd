extends Node

@onready var tilemap: Node = $tilemap

var floors: Array[int] = [0]

var F: int:
	get: return floors[-1]

func set_control_entity(entity: Node2D, geometry: CollisionShape2D):
	tilemap.set_control_entity(entity, geometry)

func _is_same(body: Node2D) -> bool:
	return body.get_instance_id() == get_instance_id()

func at_old_floor(body) -> void:
	if body is StaticBody2D:
		if not _is_same(body): floors.pop_back()

func at_new_floor(body) -> void:
	if body is StaticBody2D:
		if not _is_same(body): floors.push_back(body.F)
	elif body is TileMap:
		tilemap.find_tile(body)
