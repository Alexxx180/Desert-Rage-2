extends Node

@onready var push: Node = $push
@onready var press: Node = $press
@onready var fire: Node = $fire

func controls(box: CharacterBody2D) -> void:
	var lockers: Node = box.get_node("../../tags").lockers
	var work: Node = box.logic.work
	
	push.controls(box, work.push)
	press.controls(box, work.press, lockers.location.activator.button)
	fire.controls(box, work.fire, lockers.ability.freeze)
	
	work.push.directing.connect(box.logic.see.set_direction)
