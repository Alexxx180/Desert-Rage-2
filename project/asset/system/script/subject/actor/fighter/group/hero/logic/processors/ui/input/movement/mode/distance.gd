extends Node

enum { DISTANCE = 70, MULTIPLIER = 50 }

func direct(hero: CharacterBody2D, enemy: CharacterBody2D) -> Vector2:
	return hero.position.direction_to(enemy.position)

func is_safe(hero: CharacterBody2D, enemy: CharacterBody2D) -> bool:
	return hero.position.distance_to(enemy.position) > DISTANCE

func perform_motion(hero: CharacterBody2D, enemy: CharacterBody2D) -> void:
	var input: Node = hero.logic.processors.ui.input
	var direction: Vector2 = direct(hero, enemy)
	var motion: Vector2 = direction * (hero.logic.stats.speed / MULTIPLIER)
	
	input.movement.mode.velocity.set_moving(motion)
	hero.view.animation.move(motion)
	hero.make_velocity(motion)
	input.imitate_motion(direction)
