extends Node

@onready var level: Node = $level
@onready var check: Node = $check
@onready var teleport: Node = $teleport

func transit(transition: Dictionary) -> void:
	var map: Dictionary = {}
	if !check.available(map, transition): return
	
	match map.passage.cell:
		Vector2i(0, 2):
			teleport.transit(transition.hero, map.connect)
		Vector2i(2, 0):
			print("credits: ", map.passage.cell)
			level.credits()
		Vector2i(2, 1):
			print("credits: ", map.passage.cell)
			level.credits()
		_:
			print("no credits: ", map.passage.cell)
			level.elevate(transition.execute, map)
