extends Node

signal activate(pos: Vector2, dir: Vector2)

#var _burn: bool = false
var _last_position: Vector2

var _act: Area2D
var _hero: CharacterBody2D

var _has_box: bool = false
var _torch: CharacterBody2D

var hero: CharacterBody2D:
	set(value):
		_hero = value
		_act = _hero.logic.detectors.world.ability.rain.puddle

func start_freeze(box: CharacterBody2D) -> void:
	_torch = box
	_has_box = true

func stop_freeze(_box: CharacterBody2D) -> void:
	_has_box = false

func watering(_execute: TileMapLayer) -> void:
	_last_position = _hero.position + _act.position

func _input(_event: InputEvent) -> void:
	if not Input.is_action_pressed("skill_one"): return

	if _has_box and _torch.logic.relations.fire.on:
		_torch.logic.processors.fire.freeze()

	activate.emit(_last_position, _act.direction)
