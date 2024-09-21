extends Node

@onready var logic: Node = $logic

func set_control(hero: CharacterBody2D, input: Node) -> void:
	input.directing.connect(hero.set_direction)
	logic.set_control(input, hero.logic)
