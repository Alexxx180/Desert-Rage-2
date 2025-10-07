extends Node

class_name Lay

enum { WORLD = 1, BORDERS = 2, CHARACTER = 3, BOX = 5, GAP = 7, UPLAND = 8, JUMP = 200000, GRAVITY = 700000 }

var hero: CharacterBody2D
var height: float = 0
var _context: bool = true
var collision_on: bool:
	get: return _context

func context(enable: bool) -> Lay:
	_context = enable
	return self

func collide_main() -> Lay:
	var colliders: Array[int] = [WORLD, BOX, GAP, UPLAND]
	for mask in colliders: collide(mask)
	return self

func collide(mask: int) -> Lay:
	hero.set_collision_mask_value(mask, _context)
	return self

func hero_collide(value: bool) -> Lay:
	hero.set_collision_layer_value(CHARACTER, value)
	return self

func during_jump(sequence: bool, stable_ground: bool) -> void:
	if sequence:
		print("collided: ", false)
		context(false).collide_main().hero_collide(false)
	elif stable_ground:
		print("collided: ", true)
		context(true).collide_main().hero_collide(true)
