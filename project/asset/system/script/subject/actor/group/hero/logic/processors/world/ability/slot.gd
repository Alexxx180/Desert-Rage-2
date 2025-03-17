extends Node

class_name AbilitySlot

var _last_position: Vector2

var _act: Area2D
var _vessel: CharacterBody2D = Defaults.CHARACTER
var _hero: CharacterBody2D
var hero: CharacterBody2D: set = _set_hero

func _get_action_name() -> String: return "skill_two"

func _set_hero(value: CharacterBody2D) -> void:
	_hero = value

func near_box(box: CharacterBody2D) -> void:
	_vessel = box

func far_box(_box: CharacterBody2D) -> void:
	_vessel = Defaults.CHARACTER

func near_map(_execute: TileMapLayer) -> void:
	_last_position = _hero.position + _act.position

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed(_get_action_name()):
		ability()

func ability() -> void: pass
