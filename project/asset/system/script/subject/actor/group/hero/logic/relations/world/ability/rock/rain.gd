extends Node

func set_ice(hero: CharacterBody2D, rain: Node) -> void:
	var detector: Node2D = hero.logic.detectors.interaction.rain.ice
	detector.body_entered.connect(rain.breaking)
	detector.body_exited.connect(rain.release)
	
func set_torch(hero: CharacterBody2D, rain: Node) -> void:
	var detector: Node2D = hero.logic.detectors.interaction.rain.torch
	detector.body_entered.connect(rain.start_ignite)
	detector.body_exited.connect(rain.stop_ignite)

func controls(hero: CharacterBody2D, rain: Node, trigger: Node) -> void:
	return
	"""
	set_ice(hero, rain)
	set_torch(hero, rain)
	rain.activate.connect(trigger.activate)
	rain.hero = hero
	# """
