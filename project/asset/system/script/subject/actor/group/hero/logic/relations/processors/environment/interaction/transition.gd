extends Node

func controls(hero: CharacterBody2D, transition: Node) -> void:
	var detector: Node2D = hero.logic.detectors.interaction.transition

	detector.body_entered.connect(transition.encounter)
	transition.hero = hero
	transition.logic = hero.get_node("../../tags")
