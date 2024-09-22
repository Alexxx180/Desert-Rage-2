extends Node

func set_control(box: StaticBody2D, seat: Node) -> void:
	var stand: Node = box.logic.detectors.platforming.stand

	box.move.connect(seat.move)

	seat.update_view.connect(box.view.switch_stand)

	stand.body_entered.connect(seat.enable_stand)
	stand.body_exited.connect(seat.disable_stand)
