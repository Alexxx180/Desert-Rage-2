extends Node

class_name SurfaceTracker

@onready var tracking: Node = $tracking
@onready var tilemap: Node = $tilemap
@onready var floors: FloorsQueue = FloorsQueue.new()

func track(ground: Node2D) -> Vector2:
	return tracking.entity.position + ground.position

func find_floor(map: TileMapLayer, pos: Vector2) -> int:
	return Tiler.get_floor(map, pos)

func at_old_floor(_body: TileMapLayer) -> void:
	floors.remove()

func at_new_floor(surface: TileMapLayer) -> void:
	floors.append(tilemap.find_floor_tile(surface, tracking))