extends Node

var weight: int = 0

var hero: CharacterBody2D

func make(motion: Vector2) -> void:
	hero.make_velocity(motion)
	hero.view.animation.move(motion)

func forget() -> void:
	make(Vector2.ZERO)

func travel(motion: Vector2) -> void:
	# motion.y *= axis
	var velocity: Vector2 = hero.logic.stats.decide_travel(weight, motion)
	make(velocity)
	hero.logic.work.world.skills.pull.apply_velocity(velocity)
