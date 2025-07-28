extends Node

func controls(hero: CharacterBody2D, spring: Node) -> void:
	var detector: Node2D = hero.logic.detectors.platforming.spring
	var control: Node = hero.logic.processors.ui.input.movement.mode.control

	spring.hero = hero
	
	detector.ground.body_entered.connect(spring.spring_enter)
	detector.ground.body_exited.connect(spring.spring_exit)

	control.platform = detector.platform
	control.slide = detector.slide
	control.landing.connect(spring.successfully_landed)

	# detector.platform.body_exited.connect(spring.successfully_landed)
