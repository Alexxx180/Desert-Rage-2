extends Node

func set_control(box: StaticBody2D, seat: Node) -> void:
	var stand: Node = box.logic.detectors.platforming.stand
	var surface: Node = box.logic.processors.movement.surface

	seat.place.refresh.connect(box.view.switch_stand)

	box.move.connect(seat.transport)
	surface.floors.update.connect(seat.set_floor)

	stand.body_entered.connect(seat.enable_stand)
	stand.body_exited.connect(seat.disable_stand)
