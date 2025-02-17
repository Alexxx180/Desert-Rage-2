extends Node

func controls(hero: CharacterBody2D, fire: Node, trigger: Node) -> void:
	var detector: Node2D = hero.logic.detectors.interaction.fire.ice

	detector.body_entered.connect(fire.breaking)
	detector.body_exited.connect(fire.release)
	fire.activate.connect(trigger.activate)
	fire.hero = hero
