extends Node

func controls(hero: CharacterBody2D, fight: Node) -> void:
	var detector: Node2D = hero.logic.detectors.fight
	
	detector.close.body_entered.connect(fight.close.enter_range)
	detector.close.body_exited.connect(fight.close.exit_range)

	detector.zone.body_entered.connect(fight.zone.enter_range)
	detector.zone.body_exited.connect(fight.zone.exit_range)
	
	hero.view.animation.effect.close_damage.connect(fight.close.hit)
