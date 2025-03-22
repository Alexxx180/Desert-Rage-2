extends Node

func controls(box: CharacterBody2D, press: Node, button: Node) -> void:
	var detector: Area2D = box.logic.detectors.press
	detector.body_entered.connect(press.encounter)
	detector.body_exited.connect(press.diverge)
	
	press.activate.connect(button.activate)
	press.deactivate.connect(button.deactivate)
	press.box = box
