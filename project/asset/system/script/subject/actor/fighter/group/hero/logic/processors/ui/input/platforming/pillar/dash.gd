extends Node

var hero: CharacterBody2D
var walls: Node2D:
	get: return hero.logic.see.platforming.pillar.jump_zone

var ledge: Node
var caught: bool = false
var jump_offset: float = 0
var target_pos: Vector2
var rotation: Dictionary = { Vector2i(1, 0): 0, Vector2i(0, 1): 90, Vector2i(-1, 0): 180, Vector2i(0, -1): -90 }

func ledge_is_near() -> bool:
	var floors: Node = hero.logic.work.input.platforming.jump.feet.floors
	for pillar in walls.jump_zone.walls:
		if pillar.is_colliding():
			target_pos = walls.jump_zone.position + pillar.position
			return floors.same_to_hero(target_pos)
	return false

func is_near() -> bool:
	return not walls.jump_zone.border.is_colliding() and ledge_is_near()

func _set_ledge_offset(next: Node, offset: float) -> void:
	ledge = next
	jump_offset = offset

func whip_caught(_execute: TileMapLayer) -> void: caught = true
func whip_left(_execute: TileMapLayer) -> void: caught = false

func whip_catch(input: Node, pos: Vector2) -> void:
	if pos.x != 0: return
	input.movement.type.move.dash(pos, "go")
	hero.view.animation.moves.set_hang_move("whip_dash")

func whip_strike(input: Node, pos: Vector2) -> void:
	input.movement.type.move.dash(pos, "whip_dash")

func rotate_whip(pos: Vector2) -> Vector2:
	var direction: Vector2 = hero.logic.see.platforming.direction
	hero.view.whip.rotation_degrees = rotation[direction]
	return pos + jump_offset * direction
