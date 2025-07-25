extends Node

enum { WORLD = 1, BORDERS = 2, CHARACTER = 3, BOX = 5, GAP = 7, UPLAND = 8 }

var hero: CharacterBody2D
var collision_on: bool = true

func turn_walls_collision(value: bool) -> void:
	collision_on = value
	for mask in [WORLD, BORDERS, BOX, GAP, UPLAND]:
		hero.set_collision_mask_value(mask, value)
	set_hero_collision(value)

func set_hero_collision(value: bool) -> void:
	hero.set_collision_layer_value(CHARACTER, value)

func during_jump(sequence: bool, stable_ground: bool) -> void:
	if sequence:
		turn_walls_collision(false)
	elif stable_ground:
		turn_walls_collision(true)
