extends Node

@onready var levels: Node = $levels
@onready var check: Node = $check
@onready var teleport: Node = $teleport

func setup(tags: TileMapLayer, execute: TileMapLayer) -> void:
	teleport.fill(tags, execute)
	check.set_layers(execute, tags)
	levels.connect_levels(tags.curtain, check)
	levels.floors.assign(tags.get_parent().name.trim_prefix("map"))

func transit(hero: CharacterBody2D) -> void:
	var map: Dictionary = { "pos": hero.position }
	if !check.transitable(map): return
	
	match map.way.atlas:
		Vector2i(0, 2):
			teleport.transit(hero, map.link)
		Vector2i(2, 0):
			print("credits: ", map.way.atlas)
			levels.credits()
		Vector2i(2, 1):
			print("credits: ", map.way.atlas)
			levels.credits()
		_:
			print("no credits: ", map.way.atlas)
			levels.elevate(check.execute, map)
