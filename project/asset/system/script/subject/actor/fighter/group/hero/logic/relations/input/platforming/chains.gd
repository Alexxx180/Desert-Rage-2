extends Node

func controls(hero: CharacterBody2D, chains: Node) -> void:
	var input: Node = hero.logic.processors.ui.input
	var detector: Node2D = hero.logic.detectors.platforming.chains

	detector.pillar.body_entered.connect(chains.climbing_start)
	detector.pillar.body_exited.connect(chains.climbing_stop)

	detector.unit.body_entered.connect(chains.move_above)
	detector.unit.body_exited.connect(chains.move_under)

	chains.input = input
