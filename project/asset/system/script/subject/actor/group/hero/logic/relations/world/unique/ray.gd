extends Node

var _detector: Area2D
var _hero: CharacterBody2D

func read_book(execute: TileMapLayer) -> void:
	var tile: Dictionary = Tile.from_pos(execute, _hero.position + _detector.position)
	if tile.atlas.x % 2 == 0:
		tile.atlas.x += 1
		Tile.paint(execute, tile)
	execute.show_text(tile.coords)

func distract(execute: TileMapLayer) -> void:
	execute.hide_text()

func controls(hero: CharacterBody2D) -> void:
	_hero = hero
	_detector = hero.logic.detectors.world.unique
	_detector.body_entered.connect(read_book)
	_detector.body_exited.connect(distract)
