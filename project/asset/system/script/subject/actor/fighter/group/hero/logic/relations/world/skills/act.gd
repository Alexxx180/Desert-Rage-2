extends Node

func controls(hero: CharacterBody2D, act: Node, trigger: Node) -> void:
	var see: Node2D = hero.logic.see.world.skills.act

	see.body_entered.connect(act.encounter)
	see.body_exited.connect(act.diverge)
	act.activate.connect(trigger.activate)
	act.hero = hero
