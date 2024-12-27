extends Node

@export_file var credits_level: String = ""

const LEVEL: String = "res://asset/system/scene/usable/level/%s/%s/%d/level.tscn"
const SOURCE_ATLAS: String = "transition"
const ATLAS_SIZE: int = 5

var teleporters: Dictionary = {} # int, Node2D

@onready var tree: SceneTree = get_tree()

var tags: TileMapLayer
var next_level: bool = false

func get_next_floor(next: int) -> String:
	var level: int = SessionStats.location.level.x + next
	print("next: ", next, ", level: ", SessionStats.location.level.x)
	
	if level == 0: return "0"
	elif level < 0: return "-/%d" % abs(level)

	return "+/%d" % abs(level)

func load_credits() -> void:
	next_level = true
	#tree.change_scene_to_file(credits_level)
	tags.curtain.start_transition(credits_level)

func elevate_level(floor_diff: int, p: int) -> void:
	next_level = true
	var F: String = get_next_floor(floor_diff)
	print("CHANGE: ", LEVEL % [SessionStats.location.name, F, p])
	tags.curtain.start_transition(LEVEL % [SessionStats.location.name, F, p], floor_diff)

func transit(execute: TileMapLayer, hero: CharacterBody2D) -> void:
	print("NEXT LEVEL")
	if next_level: return
	var tile: Dictionary = Tiling.atlas(tags, hero.position)
	
	print("ATLAS SOURCE: ", tile.name)
	
	var none: bool = tile.name == "none"
	
	if !none and tile.name != SOURCE_ATLAS: return
	var passage: Dictionary = Tiling.atlas(execute, hero.position)

	match passage.cell:
		Vector2(0, 2):
			assert(tile.name == "none", "Teleporter not connected!")
			hero.teleport(teleporters[Tiling.logic(tile.cell)])
		Vector2(2, 0), Vector2(2, 1):
			load_credits()
		_:
			var f: int = Tiling.custom(execute, passage.coords, Tiling.FLOOR)
			#print("F: ", f, ", passage: ", passage.cell)
			var p: int = 0
			if !none: p = Tiling.logic(tile.cell) # Tiling.custom(tags, tile.coords, Tiling.LEVEL)
			elevate_level(f, p)
