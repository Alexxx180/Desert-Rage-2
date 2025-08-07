extends Node

signal activate(pos: Vector2)
signal deactivate(pos: Vector2)

@onready var stomp: Node = $stomp
@onready var throw: Node = $throw

var standing: bool = false
var _last_position: Vector2
var _hero: CharacterBody2D

var hero: CharacterBody2D:
	set(value): _hero = value

func encounter(_execute: TileMapLayer) -> void:
	_last_position = _hero.position
	activate.emit(_last_position)
	standing = true

func diverge(_execute: TileMapLayer) -> void:
	deactivate.emit(_last_position)
	standing = false
