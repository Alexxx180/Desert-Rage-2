extends Node

func set_control(detector: Area2D, processor: Node) -> void:
	detector.body_entered.connect(processor.on_ledge_encounter)
