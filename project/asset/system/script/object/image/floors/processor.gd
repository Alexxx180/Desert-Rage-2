extends Node

signal update_floor(f: int)
#@onready var queue: FloorsQueue = FloorsQueue.new()
@onready var tracker: SurfaceTracker = $tracker

#func at_old_floor(_tiles: TileMapLayer) -> void:
#	queue.remove()
var _floor: int = 0
var F: int:
	get: return _floor

func at_new_floor(border: TileMapLayer) -> void:
	var map_coords: Vector2i = Tile.find(border, tracker.contact)
	_floor = Tile.extract(border, map_coords, Tile.FLOOR)
	update_floor.emit(_floor)
