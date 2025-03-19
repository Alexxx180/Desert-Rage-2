extends Node

signal update_floor(f: int)

@onready var tracker: SurfaceTracker = $tracker

var freeze: bool = false
var _floor: int = 0
var F: int:
	get: return _floor

func at_new_floor(border: TileMapLayer) -> void:
	if freeze:
		print("Set Floor [FREEZE] = ", F)
		return

	var map_coords: Vector2i = Tile.find(border, tracker.contact)
	_floor = Tile.extract(border, map_coords, Tile.FLOOR)
	update_floor.emit(_floor)
	print("Set Floor = ", _floor)

func set_box_floor(next: int) -> void:
	_floor = next
	update_floor.emit(_floor)
	print("Set Floor = ", _floor)
