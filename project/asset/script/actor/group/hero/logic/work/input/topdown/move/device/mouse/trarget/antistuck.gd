extends Node

enum { DISTANCE = 60, MULTIPLIER = 50 }

func direct(hero: CharacterBody2D, pos: Vector2) -> Vector2:
	return hero.position.direction_to(pos)

func is_safe(hero: CharacterBody2D, pos: Vector2) -> bool:
	return hero.position.distance_to(pos) > DISTANCE

func lock_attack(hero: CharacterBody2D) -> void:
	hero.view.animation.moves.set_fight_start("active")
	hero.view.animation.moves.set_fighting("hands")
	hero.logic.work.input.move.act.velocity.forget()

func set_moving(hero: CharacterBody2D, direction: Vector2) -> void:
	var motion: Vector2 = direction * (hero.logic.stats.speed / MULTIPLIER)
	hero.logic.work.input.movement.move.turn_around(motion)
	# hero.logic.work.input.movement.move.velocity.set_moving(motion)
	# hero.logic.work.input.modes.current.access(direction.normalized())
	# hero.view.animation.move(motion)

func perform_motion(hero: CharacterBody2D, enemy: CharacterBody2D) -> void:
	var direction: Vector2 = direct(hero, enemy.position)
	
	for i in range(0, 2):
		if hero.logic.see.fight.stuck[i].is_colliding():
			direction[i] = 0
			direction[(i + 1) % 2] *= 2
			break
	
	set_moving(hero, direction)
