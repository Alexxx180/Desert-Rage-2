extends Node

func controls(hero: CharacterBody2D, pull: Node) -> void:
	var detector: Node2D = hero.logic.detectors.interaction.pull

	detector.body_entered.connect(pull.start_forward)
	detector.body_exited.connect(pull.stop_forward)
	pull.hero = hero
