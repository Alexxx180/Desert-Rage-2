extends Node

signal standing(box: CharacterBody2D, hero: CharacterBody2D)
signal leaving(box: CharacterBody2D, hero: CharacterBody2D)

const EMPTY_SEAT: int = 0

var _hero_id: int = EMPTY_SEAT
var stand: Area2D
var entity: CharacterBody2D
var border: TileDecorator

func get_floor() -> int: # var coords: Vector2i = Tile.find(border, )
	return border.extract_at_pos(entity.position, Tile.FLOOR)

func empty() -> bool: return _hero_id == EMPTY_SEAT

func same(hero: CharacterBody2D) -> bool:
	return _hero_id == hero.get_instance_id()

func stay(hero: CharacterBody2D) -> void: standing.emit(entity, hero)

func leave(hero: CharacterBody2D) -> void: leaving.emit(entity, hero)

func is_in_midair(hero: CharacterBody2D) -> bool:
	return hero.to.topdown.levels.jump.feet.unstable

func visit(hero: CharacterBody2D, id: int = EMPTY_SEAT) -> void:
	hero.view.visible = !is_in_midair(hero) # print("VISIBLE HERO: ", hero.view.visible)
	_hero_id = id
