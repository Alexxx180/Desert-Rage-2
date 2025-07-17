extends Node

func controls(hero: CharacterBody2D, fight: Node) -> void:
	var detector: Node2D = hero.logic.detectors.fight
	
	detector.close.body_entered.connect(fight.close.enter_range)
	detector.close.body_exited.connect(fight.close.exit_range)

	detector.zone.body_entered.connect(fight.zone.enter_range)
	detector.zone.body_exited.connect(fight.zone.exit_range)
	
	var tension: Node = hero.get_node("../../ost").tension
	
	detector.music.nearby.body_entered.connect(tension.add_enemy)
	detector.music.nearby.body_exited.connect(tension.drop_enemy)

	detector.music.spawn.body_entered.connect(tension.add_spawn)
	detector.music.spawn.body_exited.connect(tension.drop_spawn)

	hero.view.animation.close_damage.connect(fight.close.hit)
	
