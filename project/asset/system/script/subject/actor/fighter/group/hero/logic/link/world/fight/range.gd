extends Node

func controls(hero: CharacterBody2D, fight: Node) -> void:
	var see: Node2D = hero.logic.see.fight
	
	see.close.body_entered.connect(fight.close.enter_range)
	see.close.body_exited.connect(fight.close.exit_range)

	see.zone.body_entered.connect(fight.zone.enter_range)
	see.zone.body_exited.connect(fight.zone.exit_range)

	var act: Node = hero.logic.work.world.skills.act

	see.after_tile.body_entered.connect(act.lever.after_tile.enter_range)
	see.after_tile.body_exited.connect(act.lever.after_tile.exit_range)

	see.sided.body_entered.connect(act.book.sided.enter_range)
	see.sided.body_exited.connect(act.book.sided.exit_range)

	hero.view.animation.effect.close_damage.connect(fight.close.hit)
