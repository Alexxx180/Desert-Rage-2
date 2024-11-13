extends Node

func set_control(box: CharacterBody2D, surface: Node) -> void:
	var floors: Area2D = box.logic.detectors.platforming.floors

	# box.directing.connect(surface.tracking.map.set_direction)

	floors.body_entered.connect(surface.at_new_floor)
	floors.body_exited.connect(surface.at_old_floor)

	#surface.floors.update.connect(box.logic.processors.movement.seat.set_floor)

	surface.tracking.set_contacts(box.geometry.shape.size)
	surface.tracking.entity = box
