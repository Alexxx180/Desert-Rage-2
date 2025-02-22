extends Node

@onready var push: Node = $push
@onready var press: Node = $press

func controls(box: CharacterBody2D) -> void:
	var activators: Node = box.get_node("../../tags").activators
	var processor: Node = box.logic.processors
	
	push.controls(box, processor.push)
	press.controls(box, processor.press, activators.button)
