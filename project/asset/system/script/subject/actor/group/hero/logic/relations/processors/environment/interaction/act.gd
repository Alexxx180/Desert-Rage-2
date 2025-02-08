extends Node

func controls(hero: CharacterBody2D, act: Node, tags: TileMapLayer) -> void:
	var detector: Node2D = hero.logic.detectors.interaction.act

	detector.body_entered.connect(act.encounter)
	act.set_level(hero, tags)
	act.hero = hero
