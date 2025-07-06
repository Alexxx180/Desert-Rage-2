extends Node

var _detector: Area2D
var _hero: CharacterBody2D
var category: String = ""

func read_book(execute: TileMapLayer, tile: Dictionary) -> void:
	execute.show_text(tile.coords)

	if tile.atlas.x % 2 == 0:
		tile.atlas.x += 1
		Tile.paint(execute, tile)

func determine_static(execute: TileMapLayer) -> void:
	category = ""
	var tile: Dictionary = Tile.from_pos(execute, _hero.position + _detector.position)
	match tile.atlas:
		Vector2i(2, 1): execute.show_text(tile.coords)
		Vector2i(2, 3):
			category = "hp"
			execute.recovery.recover(_hero, category)
		Vector2i(3, 3): 
			category = "ap"
			execute.recovery.recover(_hero, category)
		_: read_book(execute, tile)

func distract(execute: TileMapLayer) -> void:
	execute.hide_text()
	if category != "":
		execute.recovery.stop_recover(_hero, category)
		category = ""

func controls(hero: CharacterBody2D) -> void:
	_hero = hero
	_detector = hero.logic.detectors.world.unique
	_detector.body_entered.connect(determine_static)
	_detector.body_exited.connect(distract)
