extends Node

var _level: Dictionary = {}

func set_level(hero: CharacterBody2D, logic: TileMapLayer) -> void:
	_level.hero = hero
	_level.tags = logic

func encounter(execute: TileMapLayer) -> void:
	_level.pos = _level.hero.position
	_level.execute = execute
	_level.tags.activators.activate(_level)
