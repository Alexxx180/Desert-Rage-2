extends Node

func controls(hero: CharacterBody2D, spring: Node) -> void:
	var detector: Node2D = hero.logic.detectors.platforming.spring

	spring.hero = hero
	
	detector.ground.body_entered.connect(spring.spring_enter)
	detector.ground.body_exited.connect(spring.spring_exit)

	detector.platform.body_exited.connect(spring.successfully_landed)
