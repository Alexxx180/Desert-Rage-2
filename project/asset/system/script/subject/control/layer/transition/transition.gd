extends Node

@onready var levels: Node = $levels
@onready var check: Node = $check
@onready var teleport: Node = $teleport

func transit(level: Dictionary) -> void:
	var map: Dictionary = {}
	if !check.available(map, level): return
	
	match map.passage.cell:
		Vector2i(0, 2):
			teleport.transit(level.hero, map.connect)
		Vector2i(2, 0):
			print("credits: ", map.passage.cell)
			levels.credits()
		Vector2i(2, 1):
			print("credits: ", map.passage.cell)
			levels.credits()
		_:
			print("no credits: ", map.passage.cell)
			levels.elevate(level.execute, map)
