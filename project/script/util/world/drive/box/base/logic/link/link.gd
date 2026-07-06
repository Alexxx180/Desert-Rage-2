extends Node

@onready var movement: Node = $movement
@onready var press: Node = $press

func controls(box: CharacterBody2D) -> void:
	var activator: Node = box.get_node("../../tags").lockers.location.activator
	movement.controls(box, box.logic.work.move)
	press.controls(box, box.logic.work.press, activator.button)
