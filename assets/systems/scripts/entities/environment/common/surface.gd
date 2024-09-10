extends Node

@onready var tilemap: Node = $tilemap

@onready var floors = FloorsQueue.new()

func set_control_entity(entity: Node2D, velocity: Node, geometry: CollisionShape2D):
	tilemap.set_control_entity(entity, velocity, geometry)

func _is_same(body: Node2D) -> bool:
	return body.get_instance_id() == get_instance_id()

func at_old_floor(body) -> void:
	if body is StaticBody2D:
		if not _is_same(body): floors.remove()
	elif body is TileMap:
		floors.remove()

func at_new_floor(body) -> void:
	if body is StaticBody2D:
		if not _is_same(body): floors.append(body.F)
	elif body is TileMap:
		floors.append(tilemap.find_tile(body))
