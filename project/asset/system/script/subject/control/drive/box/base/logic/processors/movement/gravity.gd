extends Node

enum { WORLD = 1, BORDERS = 2, GAP = 7, UPLAND = 8 } # , JUMP = 200000, GRAVITY = 700000
# CHARACTER = 3, BOX = 5
var box: CharacterBody2D
var collision_on: bool = true
# var height: float = 0

func turn_walls_collision(value: bool, borders: bool = false) -> void:
	print("BOX - ENABLED COLLISION: ", value)
	collision_on = value
	var colliders: Array[int] = [WORLD, GAP, UPLAND] # BOX,
	if not borders: colliders.push_front(BORDERS)
	for mask in colliders:
		box.set_collision_mask_value(mask, value)
