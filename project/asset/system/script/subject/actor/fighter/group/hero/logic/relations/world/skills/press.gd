extends Node

func controls(hero: CharacterBody2D, press: Node, button: Node) -> void:
	var detector: Node2D = hero.logic.detectors.world.skills.press

	detector.body_entered.connect(press.encounter)
	detector.body_exited.connect(press.diverge)

	press.activate.connect(button.activate)
	press.deactivate.connect(button.deactivate)
	press.hero = hero

	var circle: Area2D = hero.logic.detectors.fight.small_circle

	circle.body_entered.connect(press.stomp.small_circle.enter_range)
	circle.body_exited.connect(press.stomp.small_circle.exit_range)

	press.throw.hero = hero
