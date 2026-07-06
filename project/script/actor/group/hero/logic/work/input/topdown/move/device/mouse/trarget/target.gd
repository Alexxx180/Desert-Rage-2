extends Node

var locked: bool = false
var hero: CharacterBody2D

@onready var antistuck: Node = $antistuck
@onready var _enemy: CharacterBody2D = HUD.ENTITY

var enemy: CharacterBody2D:
	set(value): _enemy = value#; select_mode(!no_target())

var _target_pos: Vector2 = Vector2.ZERO
var target_pos: Vector2:
	set(value): _target_pos = value# ; select_mode(value != Vector2.ZERO)

func end_fight() -> void:
	antistuck.perform_motion(hero, hero)
	reset_target()

func no_target() -> bool: return _enemy == HUD.ENTITY
func reset_target() -> void:
	enemy = HUD.ENTITY
	locked = false

func hero_lock_move() -> void:
	pass
	# hero.move_and_slide()

func hero_lock_attack() -> void:
	locked = true # print("locked to target")
	antistuck.lock_attack()

func hero_choice(pos: Vector2) -> void:
	if antistuck.is_safe(hero, pos) and not locked:
		hero_lock_move() # print("MOVING!")
	elif not locked:
		hero_lock_attack()

func targeted(_delta: float) -> void:
	var pos: Vector2 = _target_pos if no_target() else _enemy.position
	antistuck.perform_motion(hero, pos)
	hero_choice(pos)
