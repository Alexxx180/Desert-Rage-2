extends Node

signal activate(pos: Vector2)

var _allow: bool = false
var _last_position: Vector2

var _act: Area2D
var _hero: CharacterBody2D

var hero: CharacterBody2D:
	set(value):
		_hero = value
		_act = _hero.logic.detectors.world.skills.act

func encounter(_execute: TileMapLayer) -> void:
	_last_position = _hero.position + _act.position
	_allow = true
	#print("ENCOUNTER! ", _hero.position + _act.position)

func diverge(_execute: TileMapLayer) -> void:
	_allow = false

func _input(_event: InputEvent) -> void:
	if _allow and Input.is_action_pressed("action"):
		activate.emit(_last_position)
