extends Node

signal activate(pos: Vector2)

var _allow: bool = false
var _last_position: Vector2

var _act: Area2D
var _hero: CharacterBody2D

var _has_box: bool = false
var _torch: CharacterBody2D

var hero: CharacterBody2D:
	set(value):
		_hero = value
		_act = _hero.logic.detectors.interaction.fire.ice

func start_ignite(box: CharacterBody2D) -> void:
	_torch = box
	_has_box = true

func stop_ignite(_box: CharacterBody2D) -> void:
	_has_box = false

func breaking(_execute: TileMapLayer) -> void:
	_last_position = _hero.position + _act.position
	_allow = true

func release(_execute: TileMapLayer) -> void:
	_allow = false
	_torch = null

func _input(_event: InputEvent) -> void:
	if _has_box and !_torch.logic.relations.fire.on:
		_torch.ignite()

	if _allow and Input.is_action_pressed("skill_one"):
	#	print("PRESS")
		activate.emit(_last_position)
	#else:
	#	print("NOT PRESS, cause: ", _allow)
