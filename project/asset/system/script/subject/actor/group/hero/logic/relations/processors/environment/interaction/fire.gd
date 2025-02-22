extends Node

func set_ice(hero: CharacterBody2D, fire: Node) -> void:
	var detector: Node2D = hero.logic.detectors.interaction.fire.ice
	detector.body_entered.connect(fire.breaking)
	detector.body_exited.connect(fire.release)
	
func set_torch(hero: CharacterBody2D, fire: Node) -> void:
	var detector: Node2D = hero.logic.detectors.interaction.fire.torch
	detector.body_entered.connect(fire.start_ignite)
	detector.body_exited.connect(fire.stop_ignite)

func controls(hero: CharacterBody2D, fire: Node, trigger: Node) -> void:
	set_ice(hero, fire)
	set_torch(hero, fire)
	fire.activate.connect(trigger.activate)
	fire.hero = hero
