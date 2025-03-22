extends Node

func controls(hero: CharacterBody2D, press: Node, button: Node) -> void:
	var detector: Node2D = hero.logic.detectors.world.skills.press

	detector.body_entered.connect(press.encounter)
	detector.body_exited.connect(press.diverge)

	press.activate.connect(button.activate)
	press.deactivate.connect(button.deactivate)
	press.hero = hero
