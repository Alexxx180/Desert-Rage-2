extends Node

var _platforming: Node
var _overleap: Node2D

func controls(hero: CharacterBody2D, input: Node, overleap: Node2D) -> void:
	var jump: Node = hero.logic.processors.ui.input.platforming.jump

	_platforming = hero.logic.processors.ui.input.platforming
	_platforming.jump.border = hero.get_node("../../border")

	_overleap = overleap

	overleap.gap.body_entered.connect(_on_ledge_encounter_gap)
	overleap.upland.body_entered.connect(_on_ledge_encounter_upland)

func _make_single_jump_response(gap: bool) -> void:
	print("JUMP THROUGH GAP: ", gap)
	_platforming.gap.available = gap
	_platforming.upland.available = !gap
	# Processors.turn(_platforming, truetarget_position = direction * ray)

func _on_ledge_encounter_gap(_surface: TileMapLayer) -> void:
	_make_single_jump_response(true)

func _on_ledge_encounter_upland(_surface: TileMapLayer) -> void:
	_make_single_jump_response(false)
