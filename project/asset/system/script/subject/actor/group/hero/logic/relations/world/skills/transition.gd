extends Node

func controls(hero: CharacterBody2D, transition: Node, tags: TileMapLayer) -> void:
	var detector: Node2D = hero.logic.detectors.world.skills.transition

	detector.body_entered.connect(transition.encounter)

	transition.transit.connect(tags.transition.transit)
	transition.hero = hero
