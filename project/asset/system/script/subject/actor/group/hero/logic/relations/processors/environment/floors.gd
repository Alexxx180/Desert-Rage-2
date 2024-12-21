extends Node

func controls(hero: CharacterBody2D, floors: Node, detector: Node) -> void:
	var jump: Node = hero.logic.processors.input.platforming.jump

	floors.tracker.entity = hero
	# floors.tracker.contact_zone = detector

	detector.contact.connect(floors.tracker.set_contact)

	floors.queue.update.connect(jump.overview.height.set_floor)

	detector.body_entered.connect(floors.at_new_floor)
	detector.body_exited.connect(floors.at_old_floor)
	"""
	_contact = hero.get_node("../../contact")
	surface.margin.debug_contact.connect(_debug_contact)

var _contact: Node2D

func _debug_contact(contact: Vector2) -> void:
	_contact.position = contact
#"""
