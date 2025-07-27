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

const BORDERS: float = 17.0

var rotation: Dictionary = { Vector2i(1, 0): 0, Vector2i(0, 1): 90,
	Vector2i(-1, 0): 180, Vector2i(0, -1): -90 }

func set_ledge(is_chains: bool) -> void:
	if is_chains:
		ledge = chains
		jump_offset = 0
	else:
		ledge = pillars
		jump_offset = BORDERS / 2

func _turn_collision(state: bool) -> void:
	gravity.turn_walls_collision(state)
	dashed = !state

func whip_caught(_execute: TileMapLayer) -> void:
	caught = true

func whip_left(_execute: TileMapLayer) -> void:
	caught = false

func whip_dashed() -> void: _turn_collision(true)

func _perform_dash(pos: Vector2) -> void:
	#print("DASH: ", hero.position)
	var detector: Node2D = hero.logic.detectors.platforming
	#var pos: Vector2 = detector.pillar.position
	hero.view.whip.rotation_degrees = rotation[detector.direction]
	#pos += BORDERS / 2 * detector.direction
	pos += jump_offset * detector.direction
	#pos.y += jump_offset
	_turn_collision(false)
	hero.logic.processors.ui.input.movement.mode.type.dash(pos, "whip_dash")
	print("DASHED: ", hero.position)
	# _turn_collision(true)

func dash_on_whip() -> void:
	for pillar in ledge.jump_zone.walls:
		if pillar.is_colliding():
			_perform_dash(pillars.jump_zone.position + pillar.position)
			return
