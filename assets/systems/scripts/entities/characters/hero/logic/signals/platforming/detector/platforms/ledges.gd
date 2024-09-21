extends Node

func set_control(detector: Area2D, processor: Node) -> void:
	detector.body_entered.connect(processor.append)
	detector.body_exited.connect(processor.remove)
