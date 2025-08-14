extends Node

var _hero: CharacterBody2D
var hero: CharacterBody2D:
	get: return _hero
	set(value):
		_hero = value
		ledge = walls
		border = hero.get_node("../../border")
var border: TileMapLayer
var gravity: Node:
	get: return hero.logic.processors.ui.input.gravity
var walls: Node2D:
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
		if ledge.jump_zone.border.is_colliding():
			return false

		for pillar in ledge.jump_zone.walls:
			if pillar.is_colliding():
				target_pos = walls.jump_zone.position + pillar.position
				var map_coords: Vector2i = Tile.find(border, hero.position + target_pos)
				var f: int = Tile.extract(border, map_coords, Tile.FLOOR)
				print("WHIP FLOOR: ", f)
				var ignore_ground: bool = true

				return hero.logic.processors.ui.input.platforming.jump.feet.same_floor(f, ignore_ground)
		return false

const BORDERS: float = 17.0

var rotation: Dictionary = { Vector2i(1, 0): 0, Vector2i(0, 1): 90,
	Vector2i(-1, 0): 180, Vector2i(0, -1): -90 }

func set_ledge(is_chains: bool) -> void:
	if is_chains: _set_ledge_offset(chains, 0)
	else: _set_ledge_offset(walls, BORDERS / 2)

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
	if input.platforming.chains.above:
		if pos.x != 0: return
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
