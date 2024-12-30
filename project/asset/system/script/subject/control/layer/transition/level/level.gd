extends Node

signal next_level(path: String, fdiff: int)

const CREDITS: String = "res://asset/system/scene/usable/level/credits.tscn"
const LEVEL: String = "res://asset/system/scene/usable/level/%s/%s/%d/level.tscn"

@onready var floors: Node = $floors

func credits() -> void:
	print("CREDITS")
	next_level.emit(CREDITS, 0)

func elevate(execute: TileMapLayer, tiles: Dictionary) -> void:
	var diff: int = floors.differ(execute, tiles.passage)
	var part: int = 0 if tiles.none else Tiling.logic(tiles.connect.cell)
	
	var F: String = floors.get_next(diff)
	var caption: String = SessionStats.location.name
	
	next_level.emit(LEVEL % [caption, F, part], diff)
