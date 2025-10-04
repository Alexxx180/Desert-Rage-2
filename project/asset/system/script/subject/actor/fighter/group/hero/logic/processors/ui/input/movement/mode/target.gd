extends Node

var locked: bool = false
var hero: CharacterBody2D

@onready var antistuck: Node = $antistuck
@onready var _enemy: CharacterBody2D = Defaults.ENTITY

var enemy: CharacterBody2D:
	set(value): _enemy = value#; select_mode(!no_target())

var _target_pos: Vector2 = Vector2.ZERO
var target_pos: Vector2:
	set(value): _target_pos = value# ; select_mode(value != Vector2.ZERO)

func end_fight() -> void:
	antistuck.perform_motion(hero, hero)
	reset_target()

func no_target() -> bool: return _enemy == Defaults.ENTITY
func reset_target() -> void:
	enemy = Defaults.ENTITY
	locked = false
# func select_mode(state: bool) -> void: hero.movement = targeted if state else mode.control.floating
func hero_lock_move() -> void: hero.move_and_slide()

func hero_lock_attack() -> void:
	locked = true # print("locked to target")
	antistuck.lock_attack()

func targeted(delta: float) -> void:
	var pos: Vector2 = _target_pos if no_target() else _enemy.position
	antistuck.perform_motion(hero, pos)
	if antistuck.is_safe(hero, pos) and not locked:
		hero_lock_move() # print("MOVING!")
	elif not locked:
		hero_lock_attack()
