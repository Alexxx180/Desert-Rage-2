extends Node

@onready var levels: Node = $levels
@onready var check: Node = $check
@onready var teleport: Node = $teleport

func setup(tags: TileMapLayer, border: TileMapLayer) -> void:
	teleport.fill(tags, border)
	check.set_layers(border, tags)
	levels.connect_levels(tags.curtain, check)
	SessionStats.assign(tags.get_parent().name.trim_prefix("map"))

func transit(hero: CharacterBody2D) -> void:
	var map: Dictionary = { "pos": hero.position }
	if !check.transitable(map): return
	
	match map.way.atlas:
		Vector2i(0, 2):
			teleport.transit(hero, map.link)
		Vector2i(2, 0), Vector2i(2, 1):
			levels.credits()
		_: levels.elevate(check.execute, map)
