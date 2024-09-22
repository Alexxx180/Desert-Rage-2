extends Node

@onready var logic: Node = $logic
@onready var movement: Node = $movement

func set_control(hero: CharacterBody2D, input: Node) -> void:
	input.directing.connect(hero.set_direction)
	movement.set_control(input.movement, hero)
	logic.set_control(input, hero.logic)
