extends Node

var mode: Node
var locked: bool = false

@onready var _enemy: CharacterBody2D = Defaults.ENTITY
var enemy: CharacterBody2D:
	set(value): _enemy = value; select_mode(!no_target())

var _target_pos: Vector2 = Vector2.ZERO
var target_pos: Vector2:
	set(value): _target_pos = value; select_mode(value != Vector2.ZERO)

func no_target() -> bool: return _enemy == Defaults.ENTITY
func reset_target() -> void:
	enemy = Defaults.ENTITY
	locked = false

func select_mode(state: bool) -> void:
	mode.hero.movement = targeted if state else mode.control.floating

func targeted(delta: float) -> void:
	var pos: Vector2 = _target_pos if no_target() else _enemy.position
	mode.distance.perform_motion(mode.hero, pos)
	if mode.distance.is_safe(mode.hero, pos) and not locked:
		mode.hero.move_and_slide() # print("MOVING!")
	elif not locked:
		locked = true # print("LOCKED!")
		mode.fight.use_selection(mode.hero)
