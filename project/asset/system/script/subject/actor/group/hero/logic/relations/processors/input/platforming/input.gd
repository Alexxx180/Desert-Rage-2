extends Node

var _input: Node

func controls(hero: CharacterBody2D, input: Node, overleap: Node2D) -> void:
	var jump: Node = hero.logic.processors.input.platforming.jump
	var map: Node2D = hero.get_node("../..")

	_input = input
	_input.ledges = map.get_node("ledge")
	_input.gap.jump.connect(jump.floor_only)
	_input.upland.jump.connect(jump.determine)

	overleap.gap.body_entered.connect(_on_ledge_encounter_gap)
	overleap.upland.body_entered.connect(_on_ledge_encounter_upland)

func _make_single_jump_response(gap: bool) -> void:
	_input.gap.available = gap
	_input.upland.available = !gap

func _on_ledge_encounter_gap(_surface: TileMapLayer) -> void:
	#print("GAP")
	_make_single_jump_response(true)

func _on_ledge_encounter_upland(_surface: TileMapLayer) -> void:
	#print("UPLAND")
	_make_single_jump_response(false)
