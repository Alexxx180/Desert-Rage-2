extends Node

var _detector: Area2D
var _hero: CharacterBody2D
var category: String = ""

func determine_static(execute: TileMapLayer) -> void:
	category = ""
	var tile: Dictionary = Tile.from_pos(execute, _hero.position + _detector.position)
	match tile.atlas:
		Vector2i(2, 3):
			category = "hp"
			execute.recovery.recover(_hero, category)
		Vector2i(3, 3): 
			category = "ap"
			execute.recovery.recover(_hero, category)

func distract(execute: TileMapLayer) -> void:
	if category != "":
		execute.recovery.stop_recover(_hero, category)
		category = ""

func controls(hero: CharacterBody2D) -> void:
	_hero = hero
	_detector = hero.logic.see.world.unique
	_detector.body_entered.connect(determine_static)
	_detector.body_exited.connect(distract)
