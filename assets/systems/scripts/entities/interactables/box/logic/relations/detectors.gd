extends Node

func set_control(box: StaticBody2D, detectors: Node2D) -> void:
	var seat: Node = box.logic.processors.movement.seat
	var stand: Area2D = detectors.platforming.stand
	stand.box = box
	seat.stand = stand
