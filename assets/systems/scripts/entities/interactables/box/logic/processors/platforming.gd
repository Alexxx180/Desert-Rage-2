extends Node

@onready var seat: Node = $seat
@onready var platforming: Node = $platforming

func set_seat(box: Node2D):
	box.move.connect(seat.move)
	seat.update_view.connect(box.view.switch_stand)

func set_stance(detector: Area2D):
	detector.body_entered.connect(seat.enable_stand)
	detector.body_exited.connect(seat.disable_stand)

func set_floors(detector: Area2D):
	detector.body_entered.connect(platforming.at_new_floor)
	detector.body_exited.connect(platforming.at_old_floor)

func set_control_entity(box: Node2D):
	var surface: Node2D = box.detectors.platforming
	set_seat(box)
	set_stance(surface.stand)
	set_floors(surface.floors)
