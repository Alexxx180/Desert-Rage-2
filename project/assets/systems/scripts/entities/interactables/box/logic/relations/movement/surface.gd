extends Node

func controls(box: CharacterBody2D, floors: Node) -> void:
	var detector: Area2D = box.logic.detectors.platforming.floors

	# box.directing.connect(surface.tracking.map.set_direction)

	detector.contact.connect(floors.tracker.set_contact)

	#surface.floors.update.connect(box.logic.processors.movement.seat.set_floor)

	#floors.tracker.set_contacts(box.geometry.shape.size)

	box.logic.processors.movement.push.directing.connect(detector.set_direction)
	floors.tracker.entity = box

	detector.body_entered.connect(floors.at_new_floor)
	detector.body_exited.connect(floors.at_old_floor)
	#floors.tracker.contact_zone = detector

