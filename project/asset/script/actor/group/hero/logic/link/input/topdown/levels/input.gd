extends Node

var _platforming: Node
var _overleap: Node2D

func controls(hero: CharacterBody2D, input: Node, overleap: Node2D) -> void:
	pass
	# _platforming = hero.logic.work.input.levels
	
	# var jump: Node = _platforming.jump
	# _overleap = overleap

	# overleap.gap.body_entered.connect(_on_ledge_encounter_gap)
	# overleap.upland.body_entered.connect(_on_ledge_encounter_upland)

func _make_single_jump_response(gap: bool) -> void:
	print("JUMP THROUGH GAP: ", gap)
	# _platforming.jump.gap.available = gap
	# _platforming.jump.upland.available = !gap
	# Processors.turn(_platforming, truetarget_position = direction * ray)

func _on_ledge_encounter_gap(_surface: TileMapLayer) -> void:
	_make_single_jump_response(true)

func _on_ledge_encounter_upland(_surface: TileMapLayer) -> void:
	_make_single_jump_response(false)
