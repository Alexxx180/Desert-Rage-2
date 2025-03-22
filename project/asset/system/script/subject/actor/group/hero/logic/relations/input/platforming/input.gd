extends Node

var _input: Node
var _platforming: Node

func controls(hero: CharacterBody2D, input: Node, overleap: Node2D) -> void:
	var jump: Node = hero.logic.processors.input.platforming.jump
	_platforming = hero.logic.processors.input.platforming

	_input = input
	_input.ledges = hero.get_node("../../border")
	_input.gap.jump.connect(jump.floor_only)
	_input.upland.jump.connect(jump.determine)

	overleap.gap.body_entered.connect(_on_ledge_encounter_gap)
	overleap.upland.body_entered.connect(_on_ledge_encounter_upland)

func _make_single_jump_response(gap: bool) -> void:
	# print("JUMP THROUGH GAP: ", gap)
	_input.gap.available = gap
	_input.upland.available = !gap
	# Processors.turn(_platforming, truetarget_position = direction * ray)

func _on_ledge_encounter_gap(_surface: TileMapLayer) -> void:
	_make_single_jump_response(true)

func _on_ledge_encounter_upland(_surface: TileMapLayer) -> void:
	_make_single_jump_response(false)
