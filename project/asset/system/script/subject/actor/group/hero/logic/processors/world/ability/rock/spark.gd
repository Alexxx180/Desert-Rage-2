extends Node

signal activate(pos: Vector2, dir: Vector2)

#var _burn: bool = false
var _last_position: Vector2

var _act: Area2D
var _hero: CharacterBody2D

var _has_box: bool = false
var _vessel: CharacterBody2D

var hero: CharacterBody2D:
	set(value):
		_hero = value
		_act = _hero.logic.detectors.world.ability.spark.puddle

func box_near(box: CharacterBody2D) -> void:
	_vessel = box
	_has_box = true

func box_far(_box: CharacterBody2D) -> void:
	_has_box = false

func map_near(_execute: TileMapLayer) -> void:
	_last_position = _hero.position + _act.position
	#_burn = true

func map_far(_execute: TileMapLayer) -> void:
	pass
	#_burn = false

func _input(_event: InputEvent) -> void:
	if not Input.is_action_pressed("skill_two"): return

	if _has_box and !_vessel.logic.relations.spark.on:
		_vessel.logic.processors.spark.charge()

	activate.emit(_last_position, _act.direction)
