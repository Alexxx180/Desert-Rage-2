extends Node

var weight: int = 0

var hero: CharacterBody2D

func animate(motion: Vector2) -> void:
	hero.view.animation.move(motion)

func make(motion: Vector2) -> void:
	hero.make_velocity(motion)
	animate(motion)

func forget() -> void:
	make(Vector2.ZERO)

func decide(motion: Vector2) -> Vector2:
	return hero.logic.stats.decide_travel(weight, motion)

func travel(motion: Vector2) -> void:
	var velocity: Vector2 = decide(motion)
	make(velocity)
	hero.to.world.skills.pull.apply_velocity(velocity)

func platforming(motion: Vector2) -> void:
	var velocity: Vector2 = decide(motion)
	hero.make_velocity(Vector2(velocity.x, 0))
	animate(velocity) # motion.y *= axis
