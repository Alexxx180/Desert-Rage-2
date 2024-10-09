extends Node

func set_control(box: StaticBody2D, detectors: Node2D) -> void:
	print("CONNECTED")
	detectors.platforming.stand.box = box
