extends Node

@onready var queue: FloorsQueue = FloorsQueue.new()
@onready var tracker: SurfaceTracker = $tracker

func at_old_floor(_tiles: TileMapLayer) -> void:
	queue.remove()

func at_new_floor(surface: TileMapLayer) -> void:
	var contact: Vector2 = tracker.contact
	var f: int = Tiling.extract(surface, contact, Tiling.FLOOR)
	queue.append(f)
