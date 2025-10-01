extends Node

class_name AbilitySlot

var _last_position: Vector2

var aura: Node
var _act_name: String = "skill_one"
var _act: Area2D
var _hero: CharacterBody2D
var hero: CharacterBody2D: set = _set_hero

@export_range(0, 10, 1) var cost: int = 1
@onready var _vessel: CharacterBody2D = Defaults.ENTITY

func _set_hero(value: CharacterBody2D) -> void:
	_hero = value

func near_box(box: CharacterBody2D) -> void:
	_vessel = box

func far_box(_box: CharacterBody2D) -> void:
	_vessel = Defaults.ENTITY

func near_map(_execute: TileMapLayer) -> void:
	_last_position = _hero.position + _act.position
	print("HERO USING: ", _last_position)

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed(_act_name):
		ability()

func ability() -> void: pass
