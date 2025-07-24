extends Node

func controls(hero: CharacterBody2D, pillar: Node) -> void:
	var detector: Area2D = hero.logic.detectors.platforming.pillar

	pillar.hero = hero
	detector.body_entered.connect(pillar.whip_caught)
	detector.body_exited.connect(pillar.whip_left)
