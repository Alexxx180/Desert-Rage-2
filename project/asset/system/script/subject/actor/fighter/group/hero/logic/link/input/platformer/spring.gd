extends Node

func controls(hero: CharacterBody2D, jump: Node) -> void:
	var see: Node2D = hero.to.tools.spring
	var control: Node = jump.spring.control # TODOT SPRING

	control.platform = see.platform
	control.layers = hero.to.layers
	control.input = hero.logic.work.input

	control.ground = jump.spring.ground
	control.slide = jump.slide

	jump.slide.slide = see.slide
	jump.slide.walls = see.walls
	jump.slide.hero = hero
	jump.spring.ground.execute = hero.group.get_node("../tags").lay.execute
	jump.spring.spring = see.spring
