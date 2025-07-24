extends Node

var hero: CharacterBody2D
var gravity: Node:
	get: return hero.logic.processors.ui.input.gravity

var dashed: bool = false
var caught: bool = false

var rotation: Dictionary = {
	Vector2i(1, 0): 0,
	Vector2i(0, 1): 90,
	Vector2i(-1, 0): 180,
	Vector2i(0, -1): -90,
}

func _turn_collision(state: bool) -> void:
	gravity.turn_walls_collision(state)
	dashed = !state

func whip_caught(_execute: TileMapLayer) -> void:
	caught = true

func whip_left(_execute: TileMapLayer) -> void:
	caught = false

func whip_dashed() -> void: _turn_collision(true)

func dash_on_whip() -> void:
	print("TRY DASH")
	if not caught: return
	print("DASH: ", hero.position)
	var detector: Node2D = hero.logic.detectors.platforming
	var pos: Vector2 = detector.pillar.position
	hero.view.whip.rotation = rotation[detector.direction]
	_turn_collision(false)
	hero.logic.processors.ui.input.movement.mode.type.dash(pos)
	print("DASHED: ", hero.position)
	# _turn_collision(true)
