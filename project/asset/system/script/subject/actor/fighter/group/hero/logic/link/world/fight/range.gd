extends Node

func set_range(see: Node2D, work: Node, range: String) -> void:
	see.get(range).body_entered.connect(work.get(range).enter_range)
	see.get(range).body_exited.connect(work.get(range).exit_range)

func controls(hero: CharacterBody2D, fight: Node) -> void:
	var see: Node2D = hero.logic.see.fight	
	for area in ["close", "zone"]: set_range(see, fight, area)

	var act: Node = hero.logic.work.world.skills.act
	set_range(see, act.lever, "after_tile")
	set_range(see, act.book, "sided")
	hero.to.effect.close_damage.connect(fight.close.hit)
