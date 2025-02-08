extends Node

func controls(hero: CharacterBody2D, transition: Node, tags: TileMapLayer) -> void:
	var detector: Node2D = hero.logic.detectors.interaction.transition

	detector.body_entered.connect(transition.encounter)
	transition.set_level(hero, tags)
