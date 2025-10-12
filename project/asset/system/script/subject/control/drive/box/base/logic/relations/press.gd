extends Node

func controls(box: CharacterBody2D, press: Node, button: Node) -> void:
	var see: Area2D = box.logic.see.press
	see.body_entered.connect(press.encounter)
	see.body_exited.connect(press.diverge)
	
	press.activate.connect(button.activate)
	press.deactivate.connect(button.deactivate)
	press.box = box
