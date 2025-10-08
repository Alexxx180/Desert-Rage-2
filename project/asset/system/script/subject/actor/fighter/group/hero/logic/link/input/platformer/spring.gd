extends Node

func controls(hero: CharacterBody2D, jump: Node) -> void:
	var see: Node2D = hero.to.tools.spring
	var control: Node = jump.spring.control # TODOT SPRING
	var execute: TileDecorator = hero.group.lay.execute

	control.platform = see.platform
	control.layers = hero.to.layers
	control.input = hero.logic.work.input

	control.ground = jump.spring.ground
	control.slide = jump.slide

	jump.slide.slide = see.slide
	jump.slide.hero = hero
	jump.spring.execute = execute
	jump.spring.spring = see.spring
