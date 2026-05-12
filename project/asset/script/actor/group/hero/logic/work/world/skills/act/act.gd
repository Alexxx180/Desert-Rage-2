class_name SkillAct extends RefCounted

signal activate(pos: Vector2)

@onready var lever: Node = $lever
@onready var book: Node = $book

var _allow: bool = false
var is_near: bool:
	get: return _allow


var _act: Area2D
var _hero: CharacterBody2D

var hero: CharacterBody2D:
	set(value):
		_hero = value
		_act = _hero.logic.see.world.skills.act

func encounter(_execute: TileMapLayer) -> void:
	_last_position = _hero.position + _act.position
	_allow = true

func diverge(_execute: TileMapLayer) -> void:
	_allow = false

#func _input(_event: InputEvent) -> void:
#	if _allow and Input.is_action_pressed("action"):
#		activate.emit(_last_position)

func take_effect() -> void:
	activate.emit(_last_position)
