extends Node

func controls(hero: CharacterBody2D, floors: Node) -> void:
	# var jump: Node = hero.logic.processors.input.platforming.jump
	# var detector: Area2D = hero.logic.see.levels.floors

	# floors.tracker.entity = hero
	floors.border = hero.get_node("../../border")
	floors.hero = hero
	# floors.update_floor.connect(jump.overview.height.set_floor)

	# detector.contact.connect(floors.tracker.set_contact)
	# detector.body_entered.connect(floors.at_new_floor)
