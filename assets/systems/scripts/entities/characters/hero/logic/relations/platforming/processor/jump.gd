extends Node

@onready var feet: Node = $feet

func set_control(hero: CharacterBody2D, processor: Node) -> void:
	var input: Node = hero.logic.processors.input

	processor.move.connect(hero.teleport)
	feet.set_control(input, processor.feet)




