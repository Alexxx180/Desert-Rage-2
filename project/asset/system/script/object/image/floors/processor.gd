extends Node

@onready var entity: CharacterBody2D = Defaults.ENTITY

var border: TileDecorator
var hero: CharacterBody2D
var F: int: get = get_floor

func extract(pos: Vector2, height: int = 0) -> int:
	return border.extract_at_pos(pos, Tile.FLOOR) + height

func extract_at_hero(ground: Vector2) -> int:
	return extract(hero.position + ground)

func get_floor() -> int:
	if entity == Defaults.ENTITY:
		return extract(hero.position)
	else:
		return extract(entity.position, entity.height)

func same(pos: Vector2, height: int = 0) -> bool:
	var f: int = extract(pos, height)
	print("F: ", f, " ", "=" if f == F else ("<" if f < F else ">"), F, " ")
	return f == F

func same_to_hero(ground: Vector2) -> bool:
	return same(hero.position + ground)
