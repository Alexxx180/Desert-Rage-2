extends Node

func controls(hero: CharacterBody2D, act: Node, trigger: Node) -> void:
	var detector: Node2D = hero.logic.detectors.interaction.act

	detector.body_entered.connect(act.encounter)
	detector.body_exited.connect(act.diverge)
	act.activate.connect(trigger.activate)
	act.hero = hero
