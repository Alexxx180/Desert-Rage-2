extends Node

func controls(box: CharacterBody2D, floors: Node) -> void:
	var detector: Area2D = box.logic.detectors.platforming.floors
	box.logic.processors.movement.push.directing.connect(detector.set_direction)
