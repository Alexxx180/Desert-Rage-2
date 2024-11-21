extends Node

@onready var floors: FloorsQueue = FloorsQueue.new()
@onready var tracker: SurfaceTracker = $tracker

func at_old_floor(_tiles: TileMapLayer) -> void:
	floors.remove()

func at_new_floor(surface: TileMapLayer) -> void:
	var contact: Vector2 = tracker.contact
	var f: int = SurfaceTracker.get_var(surface, contact, "F", 0)
	floors.append(f)
