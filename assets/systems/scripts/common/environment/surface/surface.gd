extends Node

class_name SurfaceTracker

@onready var tracking: Node = $tracking
@onready var tilemap: Node = $tilemap
@onready var floors: FloorsQueue = FloorsQueue.new()

func track(ground: Node2D) -> Vector2:
	return tracking.hero.position + ground.position
	#tracking.get_position(ground)

func find_floor(map: TileMapLayer, pos: Vector2) -> int:
	print("MAP: ", map.name)
	return Tiler.get_floor(map, pos)
#func find_floor_tile(floors: TileMapLayer, tracking: Node) -> int:
	#return Tiler.get_floor(map, pos)

func at_old_floor(_body: TileMapLayer) -> void:
	floors.remove()

func at_new_floor(surface: TileMapLayer) -> void:
	#print("FLOOR NAME: ", walls.name)
	print("NEW FLOOR: ", surface.name)
	floors.append(tilemap.find_floor_tile(surface, tracking))
