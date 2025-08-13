extends Node

var _hero: CharacterBody2D
var hero: CharacterBody2D:
	get: return _hero
	set(value):
		_hero = value
		ledge = pillars
var gravity: Node:
	get: return hero.logic.processors.ui.input.gravity
var pillars: Node2D:
	get: return hero.logic.detectors.platforming.pillar
var chains: Node2D:
	get: return hero.logic.detectors.platforming.chains.whip

var ledge: Node
var dashed: bool = false
var caught: bool = false
var jump_offset: float = 0
var target_pos: Vector2
var is_near: bool:
	get:
		for pillar in ledge.jump_zone.walls:
			if pillar.is_colliding():
				target_pos = pillars.jump_zone.position + pillar.position
				return true
		return false

const BORDERS: float = 17.0

var rotation: Dictionary = { Vector2i(1, 0): 0, Vector2i(0, 1): 90,
	Vector2i(-1, 0): 180, Vector2i(0, -1): -90 }

func set_ledge(is_chains: bool) -> void:
	if is_chains: _set_ledge_offset(chains, 0)
	else: _set_ledge_offset(pillars, BORDERS / 2)

func _set_ledge_offset(next: Node, offset: float) -> void:
	ledge = next
	jump_offset = offset

func _turn_collision(state: bool) -> void:
	gravity.turn_walls_collision(state)
	dashed = !state

func whip_caught(_execute: TileMapLayer) -> void: caught = true
func whip_left(_execute: TileMapLayer) -> void: caught = false
func whip_dashed() -> void: _turn_collision(true)

func _selective_dash(input: Node, pos: Vector2) -> void:
	if input.platforming.chains.hanging:
		input.movement.type.move.dash(pos, "go")
		hero.view.animation.moves.set_hang_move("whip_dash")
	else:
		input.movement.type.move.dash(pos, "whip_dash")

func _perform_dash(pos: Vector2) -> void:
	var detector: Node2D = hero.logic.detectors.platforming
	hero.view.whip.rotation_degrees = rotation[detector.direction]
	pos += jump_offset * detector.direction
	_turn_collision(false)
	_selective_dash(hero.logic.processors.ui.input, pos)

func dash_on_whip() -> void:
	_perform_dash(target_pos)
