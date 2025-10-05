extends Node

func use_selection(hero: CharacterBody2D) -> void:
	hero.view.animation.moves.set_fight_start("active")
	hero.view.animation.moves.set_fighting("hands")
	hero.logic.work.input.movement.mode.velocity.forget_velocity()
