extends Node

func controls(hero: CharacterBody2D, push: Node) -> void:
	var detector: Node2D = hero.logic.detectors.interaction.push

	hero.moving.connect(push.set_velocity)

	detector.body_entered.connect(push.start_forward)
	detector.body_exited.connect(push.stop_forward)
