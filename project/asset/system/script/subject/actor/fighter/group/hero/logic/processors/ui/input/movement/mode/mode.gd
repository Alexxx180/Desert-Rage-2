extends Node

@onready var _enemy: CharacterBody2D = Defaults.CHARACTER
@onready var fight: Node = $fight
@onready var distance: Node = $distance
@onready var velocity: Node = $velocity
@onready var type: Node = $type

var hero: CharacterBody2D:
	get: return velocity.hero
	set(value):
		velocity.hero = value
		type.hero = value
		velocity.hero.movement = usual_movement

var enemy: CharacterBody2D: set = select_mode
var locked: bool = false

func reset() -> void: enemy = Defaults.CHARACTER

func select_mode(entity: CharacterBody2D) -> void:
	_enemy = entity
	if entity == Defaults.CHARACTER:
		hero.movement = usual_movement
	else:
		hero.movement = targeted_movement

func targeted_movement() -> void:
	distance.perform_motion(hero, _enemy)
	if distance.is_safe(hero, _enemy) and not locked:
		hero.move_and_slide() # print("MOVING!")
	elif not locked:
		locked = true # print("LOCKED!") 
		fight.use_selection(hero)

func end_fight() -> void:
	print("ENDED!")
	distance.perform_motion(hero, hero)
	enemy = Defaults.CHARACTER
	locked = false

func usual_movement() -> void: hero.move_and_slide()
