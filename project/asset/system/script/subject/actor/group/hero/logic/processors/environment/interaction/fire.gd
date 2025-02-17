extends Node

signal activate(pos: Vector2)

var _allow: bool = false
var _last_position: Vector2

var _act: Area2D
var _hero: CharacterBody2D
var _box: CharacterBody2D = null

var hero: CharacterBody2D:
	set(value):
		_hero = value
		_act = _hero.logic.detectors.interaction.fire.ice

func light_torch(box: CharacterBody2D) -> void:
	_box = box

func breaking(_execute: TileMapLayer) -> void:
	_last_position = _hero.position + _act.position
	_allow = true

func release(_execute: TileMapLayer) -> void:
	_allow = false
	_box = null

func _input(_event: InputEvent) -> void:
	#if _box != null:
#		_box.lighten()
	#el
	if _allow and Input.is_action_pressed("skill_one"):
		print("PRESS")
		activate.emit(_last_position)
	else:
		print("NOT PRESS, cause: ", _allow)
