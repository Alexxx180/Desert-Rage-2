extends Node

signal activate(pos: Vector2, hero: CharacterBody2D)
signal deactivate(pos: Vector2, hero: CharacterBody2D)

enum { POWER = 10, DAMAGE = 5 } # @onready var stomp: Node = $stomp # @onready var throw: Node = $throw

var _last_position: Vector2
var small_circle: FightRange = FightRange.new()

func is_near(hero) -> bool:
	return _boxes(hero).size() > 0

func encounter(hero: CharacterBody2D) -> void:
	hero.posed = hero.position
	hero.field = Bit.to(hero.field, hero.STANDING, true)
	activate.emit(hero.posed, hero)

func diverge(hero: CharacterBody2D) -> void:
	hero.field = Bit.to(hero.field, hero.STANDING, false)
	deactivate.emit(hero.posed, hero)

func _boxes(hero: CharacterBody2D) -> Array:
	return hero.to.world.skills.pull.boxes

func throw_effect(hero: CharacterBody2D) -> void: # THROW
	for box in _boxes(hero):
		box.logic.work.move.push.throw_velocity(POWER)

func stomp_effect() -> void:
	small_circle.hit(DAMAGE)
