extends Node

var _input: Node

func controls(hero: CharacterBody2D, input: Node, overleap: Node2D) -> void:
	var jump: Node = hero.logic.processors.input.platforming.jump
	var map: Node2D = hero.get_node("../..") # = overleap.get_node("../../../../../../../..") #/../map

	_input = input
	input.gap = map.get_node("gap")
	input.upland = map.get_node("upland")
	input.floors.jump.connect(jump.floor_only)
	input.ledges.jump.connect(jump.determine)

	overleap.gap.body_entered.connect(_on_ledge_encounter_gap)
	overleap.upland.body_entered.connect(_on_ledge_encounter_upland)

func _on_ledge_encounter_gap(_surface: TileMapLayer) -> void:
	_input.floors.available = true

func _on_ledge_encounter_upland(_surface: TileMapLayer) -> void:
	#print("UPLAND")
	_input.ledges.available = true
