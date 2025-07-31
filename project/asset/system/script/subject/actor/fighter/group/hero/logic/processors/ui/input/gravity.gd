extends Node

enum { WORLD = 1, BORDERS = 2, CHARACTER = 3, BOX = 5, GAP = 7, UPLAND = 8, JUMP = 200000, GRAVITY = 700000 }

var hero: CharacterBody2D
var collision_on: bool = true
var height: float = 0

func turn_walls_collision(value: bool, borders: bool = false, hero_layer: bool = false) -> void:
	collision_on = value
	var colliders: Array[int] = [WORLD, BOX, GAP, UPLAND]
	if not borders: colliders.push_front(BORDERS)
	for mask in colliders:
		hero.set_collision_mask_value(mask, value)
	set_hero_collision(hero_layer or value)

func set_hero_collision(value: bool) -> void:
	hero.set_collision_layer_value(CHARACTER, value)

func during_jump(sequence: bool, stable_ground: bool) -> void:
	if sequence:
		turn_walls_collision(false)
	elif stable_ground:
		turn_walls_collision(true)

"""
func gravity(delta: float) -> void:
	hero.velocity.y += delta * height
	if height < GRAVITY:
		height += delta * (GRAVITY + JUMP)
	print("HEIGHT: ", height)
	floating(delta)
"""
