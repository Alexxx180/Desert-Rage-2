extends Node

func set_control(detector: Area2D, floors: Node) -> void:
	detector.body_entered.connect(floors.at_new_floor)
	detector.body_exited.connect(floors.at_old_floor)
