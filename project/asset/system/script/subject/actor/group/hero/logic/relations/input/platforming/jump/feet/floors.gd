extends Node

func controls(hero: CharacterBody2D, floors: Node) -> void:
	# var jump: Node = hero.logic.processors.input.platforming.jump
	var detector: Area2D = hero.logic.detectors.platforming.floors

	floors.tracker.entity = hero
	# floors.update_floor.connect(jump.overview.height.set_floor)

	detector.contact.connect(floors.tracker.set_contact)
	detector.body_entered.connect(floors.at_new_floor)
