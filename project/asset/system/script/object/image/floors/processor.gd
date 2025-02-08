extends Node

@onready var queue: FloorsQueue = FloorsQueue.new()
@onready var tracker: SurfaceTracker = $tracker

func at_old_floor(_tiles: TileMapLayer) -> void:
	queue.remove()

func at_new_floor(surface: TileMapLayer) -> void:
	var contact: Vector2 = tracker.contact
	var map_coords: Vector2i = Tile.find(surface, contact)
	var f: int = Tile.extract(surface, map_coords, Tile.Atlas.FLOOR)
	queue.append(f)
