extends Node

signal activate(pos: Vector2)
signal deactivate(pos: Vector2)

var _last_position: Vector2
var _hero: CharacterBody2D

var hero: CharacterBody2D:
	set(value):
		_hero = value

func encounter(_execute: TileMapLayer) -> void:
	_last_position = _hero.position
	activate.emit(_last_position)

func diverge(_execute: TileMapLayer) -> void:
	deactivate.emit(_last_position)
