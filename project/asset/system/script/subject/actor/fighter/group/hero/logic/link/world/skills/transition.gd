extends Node

func controls(hero: CharacterBody2D, transition: Node, tags: TileDecorator) -> void:
	var detector: Node2D = hero.logic.see.world.skills.transition

	detector.body_entered.connect(transition.encounter)

	transition.transit.connect(tags.layer.transition.transit)
	transition.hero = hero
