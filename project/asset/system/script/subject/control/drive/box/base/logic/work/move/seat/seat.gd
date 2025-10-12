extends Node

signal move(target: Vector2)

@onready var place: Node = $place

var height: int = 1
var F: int:
	get: return place.get_floor() + height

func compare(hero: CharacterBody2D) -> bool:
	return hero.to.F == place.get_floor()

func transport(_position: Vector2) -> void:
	move.emit(place.stand.get_ledge_position()) #print("TRANSPORTED: ", target)

func enable_stand(hero: CharacterBody2D) -> void:
	if place.empty() and place.is_in_midair(hero):# print("ENABLE STAND! ", place.empty())
		place.stay(hero)
		place.visit(hero, hero.get_instance_id())

func disable_stand(hero: CharacterBody2D) -> void:
	if not place.empty() and place.same(hero):# print("DISABLE STAND? ", place.stand())
		place.leave(hero)
		place.visit(hero)
