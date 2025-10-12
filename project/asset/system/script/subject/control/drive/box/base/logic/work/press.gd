extends Node

signal activate(pos: Vector2)
signal deactivate(pos: Vector2)

@export var target = Vector2(59, 17)

var _last_position: Vector2
var _box: CharacterBody2D
var _roll: Vector2

var box: CharacterBody2D:
	set(value):
		_box = value

func set_direction(direction: Vector2):
	if direction != Vector2.ZERO:
		_roll = target * direction

func encounter(_execute: TileMapLayer) -> void:
	_last_position = _box.position# + _roll
	activate.emit(_last_position)

func diverge(_execute: TileMapLayer) -> void:
	deactivate.emit(_last_position)
