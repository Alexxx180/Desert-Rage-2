extends Node

@onready var movement: Node = $movement
@onready var press: Node = $press

func controls(box: CharacterBody2D) -> void:
	var activators: Node = box.get_node("../../tags").activators
	movement.controls(box, box.logic.processors.movement)
	press.controls(box, box.logic.processors.press, activators.button)
