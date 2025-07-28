extends Node

func controls(platform: CharacterBody2D, floors: Node) -> void:
	var detector: Area2D = platform.logic.detectors.floors
	var ride: Node = platform.logic.processors.ride

	detector.contact.connect(floors.tracker.set_contact)
	ride.directing.connect(detector.set_direction)
	
	floors.tracker.entity = platform
	detector.body_entered.connect(floors.at_new_floor)
