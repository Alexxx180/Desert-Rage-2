extends Node

func set_control(detector: Area2D, processor: Node) -> void:
	detector.body_entered.connect(processor.at_new_floor)
	detector.body_exited.connect(processor.at_old_floor)
