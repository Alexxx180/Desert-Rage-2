extends Node

const DAMAGE: int = 5

var after_tile: FightRange = FightRange.new()

var _hero: CharacterBody2D
var hero: CharacterBody2D:
	set(value):
		_hero = value

func take_effect() -> void:
	print("AREA SIZE: ", after_tile.area.size())
	after_tile.hit(DAMAGE) # hero.logic.stats.power _formula
