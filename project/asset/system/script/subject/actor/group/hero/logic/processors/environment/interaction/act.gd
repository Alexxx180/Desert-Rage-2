extends Node

var _level: Dictionary = {}

func set_level(hero: CharacterBody2D, logic: TileMapLayer) -> void:
	_level.hero = hero
	_level.tags = logic

func encounter(execute: TileMapLayer) -> void:
	var env: Node2D = _level.hero.logic.detectors.environment
	var act: Vector2 = env.interaction.act.position
	_level.pos = _level.hero.position + act
	_level.execute = execute
	_level.tags.activators.activate(_level)
