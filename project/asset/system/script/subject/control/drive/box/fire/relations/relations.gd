extends Node

@onready var push: Node = $push
@onready var press: Node = $press
@onready var fire: Node = $fire

func controls(box: CharacterBody2D) -> void:
	var behavior: Node = box.get_node("../../tags").lockers.behavior
	var processor: Node = box.logic.processors
	
	push.controls(box, processor.push)
	press.controls(box, processor.press, behavior.activator.button)
	fire.controls(box, processor.fire, behavior.ability.freeze)
	
	processor.push.directing.connect(box.logic.detectors.set_direction)
