extends Node

@onready var queue: FloorsQueue = FloorsQueue.new()
@onready var tracker: SurfaceTracker = $tracker

func at_old_floor(_tiles: TileMapLayer) -> void:
	queue.remove()

func at_new_floor(border: TileMapLayer) -> void:
	var map_coords: Vector2i = Tile.find(border, tracker.contact)
	var floor_no: int = Tile.extract(border, map_coords, Tile.FLOOR)
	queue.append(floor_no)
