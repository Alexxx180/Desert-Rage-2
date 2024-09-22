extends Node

func set_control(box: StaticBody2D, platforming: Node) -> void:
	var floors: Area2D = box.logic.detectors.platforming.floors

	box.directing.connect(platforming.tracking.set_direction)

	floors.body_entered.connect(platforming.enable_stand)
	floors.body_exited.connect(platforming.disable_stand)
