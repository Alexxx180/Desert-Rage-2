extends Node

enum { DISTANCE = 170, MULTIPLIER = 50 }

func direct(hero: CharacterBody2D, enemy: CharacterBody2D) -> Vector2:
	return hero.position.direction_to(enemy.position)

func is_safe(hero: CharacterBody2D, enemy: CharacterBody2D) -> bool:
	print("DISTANCE: ", hero.position.distance_to(enemy.position))
	return hero.position.distance_to(enemy.position) > DISTANCE

func perform_motion(hero: CharacterBody2D, enemy: CharacterBody2D) -> void:
	var input: Node = hero.logic.processors.ui.input
	var direction: Vector2 = direct(hero, enemy)
	"""
	if hero.logic.detectors.fight.stuck.x.is_colliding():
		direction.x = 0
		direction.y *= 2
	elif hero.logic.detectors.fight.stuck.y.is_colliding():
		direction.y = 0
		direction.x *= 2
	# """
		
	var motion: Vector2 = direction * (hero.logic.stats.speed / MULTIPLIER)
	input.movement.mode.velocity.set_moving(motion)
	hero.view.animation.move(motion)
	hero.make_velocity(motion)
	input.imitate(direction.normalized())
	# if direction != Vector2.ZERO:
	# 	input.platforming.jump.feet.deployment.set_direction(direction.normalized())
