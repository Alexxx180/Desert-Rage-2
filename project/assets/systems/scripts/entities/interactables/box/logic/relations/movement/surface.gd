extends Node

func controls(box: CharacterBody2D, floors: Node) -> void:
	var detector: Area2D = box.logic.detectors.platforming.floors

	# box.directing.connect(surface.tracking.map.set_direction)

	detector.body_entered.connect(floors.at_new_floor)
	detector.body_exited.connect(floors.at_old_floor)

	detector.contact.connect(floors.tracker.set_contact)

	#surface.floors.update.connect(box.logic.processors.movement.seat.set_floor)

	#floors.tracker.set_contacts(box.geometry.shape.size)
	floors.tracker.entity = box

	#floors.tracker.contact_zone = detector
