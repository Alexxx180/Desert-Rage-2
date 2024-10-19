extends Node

func set_control(box: StaticBody2D, detectors: Node2D) -> void:
	detectors.platforming.stand.box = box
