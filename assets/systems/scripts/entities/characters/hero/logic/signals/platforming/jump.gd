extends Node

@onready var feet: Node = $feet

func set_control(hero: CharacterBody2D, processor: Node) -> void:
	feet.set_control(hero.logic.processors.input, processor.feet)
	processor.move.connect(hero.teleport)
