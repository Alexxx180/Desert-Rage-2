extends Node

func controls(box: CharacterBody2D, press: Node, button: Node) -> void:
	var detector: Area2D = box.logic.detectors.press

	detector.body_entered.connect(press.encounter)
	detector.body_exited.connect(press.diverge)
	
	box.logic.processors.movement.push.directing.connect(press.set_direction)
	
	press.activate.connect(button.activate)
	press.deactivate.connect(button.deactivate)
	press.box = box
