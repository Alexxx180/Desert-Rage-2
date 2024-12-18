extends Node

signal move(target: Vector2)
signal climb(F: int)

@onready var height: Node = $height
@onready var place: Node = $place

var stand: Area2D
var _f: int = 0

var F: int:
	get: return _f + height.F

const EMPTY_SEAT: int = 0

func transport(_position: Vector2) -> void:
	var target: Vector2 = stand.get_ledge_position()
	#print("TRANSPORTED: ", target)
	move.emit(target)

func hero_climb() -> void:
	#print("F: ", _f, " + HEIGHT: ", height.F, " = ", F)
	climb.emit(F)

func set_floor(floor_level: int) -> void:
	#print("PASSED F: ", floor_level)
	_f = floor_level
	hero_climb()

func enable_stand(hero: CharacterBody2D) -> void:
	if place.empty() and place.is_in_midair(hero):
		place.stay(self, hero)
		place.visit(hero, hero.get_instance_id())

func disable_stand(hero: CharacterBody2D) -> void:
	if place.stand() and place.same(hero):
		place.leave(self, hero)
		place.visit(hero, EMPTY_SEAT)
