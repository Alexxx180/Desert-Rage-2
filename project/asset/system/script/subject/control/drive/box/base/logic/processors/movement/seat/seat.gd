extends Node

signal move(target: Vector2)
signal climb(F: int)

#@onready var height: Node = $height
@onready var place: Node = $place

var height: int = 1
var stand: Area2D

var F: int:
	get: return get_floor() + height
var entity: CharacterBody2D
var border: TileDecorator

func get_floor() -> int: # var coords: Vector2i = Tile.find(border, )
	return border.extract_at_pos(entity.position, Tile.FLOOR)

const EMPTY_SEAT: int = 0

func compare(hero: CharacterBody2D) -> bool:
	return hero.logic.processors.ui.input.platforming.jump.feet.floors.F + height == F

func transport(_position: Vector2) -> void:
	var target: Vector2 = stand.get_ledge_position()
	#print("TRANSPORTED: ", target)
	move.emit(target)

func enable_stand(hero: CharacterBody2D) -> void:
	print("ENABLE STAND! ", place.empty())
	if place.empty() and place.is_in_midair(hero):
		place.stay(self, hero)
		place.visit(hero, hero.get_instance_id())

func disable_stand(hero: CharacterBody2D) -> void:
	print("DISABLE STAND? ", place.stand())
	if place.stand() and place.same(hero):
		place.leave(self, hero)
		place.visit(hero, EMPTY_SEAT)
