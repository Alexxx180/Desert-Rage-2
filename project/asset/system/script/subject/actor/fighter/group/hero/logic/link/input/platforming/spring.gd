extends Node

func controls(hero: CharacterBody2D, jump: Node) -> void:
	var see: Node2D = hero.logic.see.levels.spring
	var control: Node = jump.spring.control
	# var jump: Node = hero.logic.work.input.platformer.tools.jump
	# var control: Node = hero.logic.work.input.platformer.tools.spring.control

	
	# see.ground.body_entered.connect(spring.spring_enter)
	# see.ground.body_exited.connect(spring.spring_exit)

	jump.slide.slide = see.slide
	control.hero = hero
	control.platform = see.platform
	control.slide = jump.slide
	jump.spring.spring = see.spring
	# jump.spring.control.landing.connect(jump.spring.successfully_landed)

	# detector.platform.body_exited.connect(spring.successfully_landed)
