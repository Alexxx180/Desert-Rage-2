extends Node

signal next_level(path: String, fdiff: int)

const CREDITS: String = "res://asset/system/scene/usable/level/credits.tscn"
const LEVEL: String = "res://asset/system/scene/usable/level/%s/%s/%d/level.tscn"

@onready var floors: Node = $floors

func connect_levels(curtain: CanvasLayer, check: Node) -> void:
	next_level.connect(curtain.start_transition)
	next_level.connect(check.next_level_transition)

func credits() -> void: next_level.emit(CREDITS, 0) ; print("CREDITS")

func elevate(execute: TileMapLayer, tiles: Dictionary) -> void:
	var diff: int = floors.differ(execute, tiles.way)
	var part: int = 0
	if tiles.link.name != "none": part = Tile.logic(tiles.link.atlas)
	
	var F: String = floors.get_next(diff)
	var caption: String = SessionStats.location.name
	
	next_level.emit(LEVEL % [caption, F, part], diff)
