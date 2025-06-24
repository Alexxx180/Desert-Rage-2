extends Node

func controls(hero: CharacterBody2D, fight: Node) -> void:
	var detector: Node2D = hero.logic.detectors.fight
	
	detector.close.body_entered.connect(fight.close.enter_range)
	detector.close.body_exited.connect(fight.close.exit_range)

	hero.view.animation.close_damage.connect(fight.close.hit)
