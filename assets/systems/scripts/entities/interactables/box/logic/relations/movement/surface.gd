extends Node

func set_control(box: StaticBody2D, surface: Node) -> void:
	var floors: Area2D = box.logic.detectors.surface.floors

	box.directing.connect(surface.tracking.map.set_direction)

	floors.body_entered.connect(surface.at_new_floor)
	floors.body_exited.connect(surface.at_old_floor)
